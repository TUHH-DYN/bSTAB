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
% - compute only once (in case of model parameter studies)

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
n_solutions = props.templ.k;

% cell array for storing the templates (collection of descriminative
% features) per solution class
ground_truth_templates = cell(n_solutions,1);

% generate the templates for each class of solutions
if props.flagShowFigures
    figure;
end

for i = 1:n_solutions
    
    % get the initial conditions and run a time integration
    [T, Y] = run_time_integration(props.model.odeFun, props.ti.tSpan, ...
        props.templ.Y0{i}, props.templ.modelParams{i}, ...
        props.ti.options, props.ti.timeStepper);
    
    % plot the template time integrations
    if props.flagShowFigures
        ax{i} = subplot(1, n_solutions, i);
        plot(T, Y); xlabel('time'); ylabel('states');
        title(['class ', num2str(i), ', label: ', props.templ.label{i}, ', PDF: ', props.roi.samplingPDF]);
    end
    
    % extract the features and store the features in the template
    ground_truth_templates{i} = props.clust.featExtractFun(T, Y, props);
    
end


if props.flagShowFigures
    linkaxes([ax{:}], 'xy');
    savefig(gcf, [props.subCasePath, '/fig_solution_templates']);
    saveas(gcf, [props.subCasePath, '/fig_solution_templates'], 'png');
    close(gcf);
end

% append the ground_truth_template to the props struct
props.templ.features = ground_truth_templates;

end