function [res_tab, res_detail, props] = compute_bs(props)
% [res_tab, res_detail, props] = compute_bs(props)

% core function that wraps all the neccessary subroutines that are required
% for computing the basin stability of a dynamical system in a fixed
% configuration, i.e. for fixed system parameter settings.

% ### input:
% - props: fully filled props struct

% ### output:
% - res_tab: overview results in table variable
% - res_detail: cell array with all the detailed results
% - props: properties struct

% ### open points:
% -

% -------------------------------------------------------------------------
% Copyright (C) 2020 Merten Stender (m.stender@tuhh.de)

% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or (at your
% option) any later version.

% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.

% You should have received a copy of the GNU General Public License along
% with this program. If not, see http://www.gnu.org/licenses/
% -------------------------------------------------------------------------

% track the computation time
tic


%% generate the grid of initial conditions

% draw initial conditions from the state space subspace specified by
% - the limits [props.ic_min_vals, props.ic_max_vals] per state dimension
% - and the number props.ic_n_points per state dimension
[ic_grid] = generate_ic_grid(props.bs.sampling_mode, props.bs.n_points, ...
    props.bs.Y0_min_vals, props.bs.Y0_max_vals, props);

% overall number of i.c.s. This may not be equal to ic_n_points, since the
% number of points per dimension will be prescribed by
% (ic_n_points)^(1/ndof), and this value gets rounded up. So we will need
% to be sure to have the correct number of initial conditions
props.bs.num_variations = size(ic_grid, 1);
props.bs.ic_n_points = [];


%% run the time integrations and classify the resulting steady-state

% initialize the arrays for storing the results
feature_array = nan(props.bs.num_variations,length(props.templates.features{1})); % store the features

% check if we have access to the progress bar package
use_ppm = exist('ParforProgressbar');
ppm = []; % ensure transparant parfor loop

% this is the main loop. Running time integrations for each i.c.,
% generating features from the time signals, classifying (assign labels)
if props.flag_par
    
    % PARFOR progress monitor (requires Instrument Control Toolbox)
    if use_ppm
        ppm = ParforProgressbar(props.bs.num_variations, 'showWorkerProgress', true, 'title', 'basin stability computation');
    else
        disp('0: Starting the PARFOR progress bar failed - probably, you do not have access to the  Instrument Control Toolbox');
    end
    
    parfor i = 1:props.bs.num_variations
        disp(['time integration ', num2str(i), '/', num2str(props.bs.num_variations)]);
        
        % perform the time integration
        [T_, Y_] = run_time_integration(props.model.ode_fun, props.ti.t_span,...
            ic_grid(i,:),props.model.ode_params,...
            props.ti.options, props.ti.time_stepper);
        
        % extract descriminative features from the time signals
        feature_array(i,:) = props.bs.feat_extract_fun(T_, Y_, props)';
        
        % increment counter to track progress
        if use_ppm
            pause(100/props.bs.num_variations);
            ppm.increment();
        end
        
    end
    
    % delete the PARFOR waitbar
    if use_ppm
        delete(ppm);
    end
    
    
else % don't use parallel computing
    for i = 1:props.bs.num_variations
        disp(['time integration ', num2str(i), '/', num2str(props.bs.num_variations)]);
        
        % perform the time integration
        [T_, Y_] = run_time_integration(props.model.ode_fun, props.ti.t_span,...
            ic_grid(i,:),props.model.ode_params,...
            props.ti.options, props.ti.time_stepper);
        
        % extract descriminative features from the time signals
        feature_array(i,:) = props.bs.feat_extract_fun(T_, Y_, props)';
    end
end


%% classification function

% do the classification based on the extracted features
[class_result] = classify_solution(feature_array, props);


%% compute the basin stability values

% admissible class labels: the members of props.ground_truth_label and 'NaN'
poss_class_labels = [categorical(props.templates.label), categorical(cellstr('NaN'))];
K = length(poss_class_labels); % K = k+1, k steady-states, 1 for NaN class

% initialize
n_k = nan(K,1);     % absolute number of class members
bs_k = nan(K,1);    % basin stability value
std_err_k = nan(K,1); % standard error (repeated Bernoulli experiment)
label_k = cell(K,1); % class label

for i=1:K
    
    % count the number of class members
    n_k(i) = sum(class_result.label==poss_class_labels(i));
    
    % compute the fraction = basin stability
    bs_k(i) = n_k(i)/props.bs.num_variations;
    
    % compute the standard error (related to the repeated Bernoulli
    % experiment, see Methods of Menck et al. NATURE)
    std_err_k(i) = sqrt((bs_k(i))*(1-bs_k(i)))/sqrt(props.bs.num_variations);
    
    % store the class label
    label_k{i} = char(poss_class_labels(i));
    
end

% summary-type table
res_tab = array2table([bs_k, n_k, std_err_k], 'VariableNames', {'basinStability', 'absNumMembers', 'standardError'});
res_tab = [cell2table(label_k, 'VariableNames', {'label'}), res_tab];
res_tab.label = categorical(res_tab.label);

% report all the details in a large cell array [n x 4]
% {y0} {features} {label} {classification error}
res_detail = cell(props.bs.num_variations, 4);
for i = 1:props.bs.num_variations
    res_detail{i,1} = ic_grid(i,:);
    res_detail{i,2} = feature_array(i,:);
    res_detail{i,3} = char(class_result.label(i));
    res_detail{i,4} = class_result.error(i);
end

% report the results on the command line
disp(['basin stability computation took ', num2str(toc), ' seconds']);

for i = 1:height(res_tab)
    disp(['basin stability of solution ', num2str(i), ', label: ', char(res_tab.label(i)), ' : S=', num2str(res_tab.basinStability(i))]);
end


end

