function [props] = generate_feature_templates(props)
% [props] = generate_feature_templates(props)

% generate the ground truth labels for each class of solutions.
% here we take the initial values supplied by the user, run a time
% integration, extract features, and take those features as a template. The
% time integration results in the basin stability procedure are classified
% based on those features.

% ### input:
% - props: properties struct

% ### output:
% - props: now including the features for the given sample points

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

% number of initial conditions supplied by the user
n_solutions = props.templates.num_solutions;

% cell array for storing the templates (collection of descriminative
% features) per solution class
ground_truth_templates = cell(n_solutions,1);

% generate the templates for each class of solutions
if props.flag_plotting
    figure;
end
for i = 1:n_solutions
    
    % get the initial conditions and run a time integration
    [T, Y] = run_time_integration(props.model.ode_fun, props.ti.t_span, ...
        props.templates.Y0{i}, props.model.ode_params, ...
        props.ti.options, props.ti.time_stepper);
    
    
    % plot the template time integrations
    if props.flag_plotting
        subplot(1, n_solutions, i)
        plot(T, Y); xlabel('time'); ylabel('states');
        title(['class ', num2str(i), ', label: ', props.templates.label{i}]);
    end
    
    % extract the features and store the features in the template
    ground_truth_templates{i} = props.bs.feat_extract_fun(T, Y, props);
    
end

if props.flag_plotting
    savefig(gcf, [props.sub_case_path, '/fig_solution_templates']);
    saveas(gcf, [props.sub_case_path, '/fig_solution_templates'], 'png');
    close(gcf);
end

% append the ground_truth_template to the props struct
props.templates.features = ground_truth_templates;

end