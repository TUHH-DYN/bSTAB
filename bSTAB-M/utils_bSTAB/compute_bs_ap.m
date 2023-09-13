function [res_tab, res_detail, props] = compute_bs_ap(props)
% [res_tab, res_detail, props] = compute_bs_ap(props)

% generate the ground truth labels for each class of solutions.
% we will generate the feature templates only once! For hyperparameter
% studies, the system does not change, so this is clear.
% For model parameter studies, we'd need template initial conditions for
% each parameter vector, which is impractical. Hence, the user needs to
% specify a feature extraction function that is general enough to scale
% from these specific feature templates to all features that will be seen
% throughout the parameter study, i.e. for changing models.


% ### input:
% - props: properties struct

% ### output:
% - res_tab: summary table
% - res_detail: cell array for the detail
% - props: updated props

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

% % % generate the feature templates only once
% % [props] = generate_feature_templates(props);

% number of parameter variations
ap_iters = length(props.ap_study.ap_values);

% initialize the results cell array
temp_res_tab = cell(ap_iters, 1);
temp_res_detail = cell(ap_iters, 1);

% run the parameter variation loop. Parallelization is performed on the
% lower level, i.e. for the n time integrations
for i = 1:ap_iters

    disp(['parameter study ', num2str(i), '/', num2str(ap_iters)]);

    % create a temp variable for the props structure
    temp_props = struct;

    % update the adaptive parameter in the props struct
    temp_props = update_props_ap(props, i);
    disp(temp_props.model.odeParams);

    % compute the basin stability value for the current parameter setting
    [temp_res_tab{i}, temp_res_detail{i}, ~] = compute_bs(temp_props);

end


if strcmp(props.clust.clustMode, 'supervised')  % we are running supervised.

    % we create a summary table that carries the most important values
    bs_vals = zeros(ap_iters, props.templ.k+1);
    err_vals = zeros(ap_iters,props.templ.k+1);
    solution_names = [props.templ.label, {'NaN'}];

    for i = 1:ap_iters % iterate the number of adaptive parameter values
        for j = 1:length(solution_names)

            % find row idx for the current solution label
            idx = find(temp_res_tab{i}.label==solution_names{j},1);
            bs_vals(i,j) = temp_res_tab{i}.basinStability(idx);
            err_vals(i,j) = temp_res_tab{i}.standardError(idx);
        end
    end

    % now create the table
    varNames = cell(1, length(solution_names)*2);
    for i = 1:length(solution_names)
        varNames{i} = strrep(['bs_',solution_names{i}], '-', '_');
        varNames{i} = genvarname(varNames{i});
        varNames{length(solution_names)+i} = ['err_', strrep(solution_names{i}, '-', '_')];
    end
    varNames = [{'parameter'}, varNames];
    res_tab = array2table([props.ap_study.ap_values',bs_vals, err_vals], 'VariableNames', varNames);

    % store all the details in a large cell array
    res_detail = temp_res_detail;


else
    res_detail = temp_res_detail;
    res_tab = temp_res_tab;
end


end

