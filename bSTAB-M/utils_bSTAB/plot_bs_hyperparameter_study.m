function plot_bs_hyperparameter_study(props, tab, varargin)
% plot_bs_hyperp_study(props, tab, plot_error)

% plot the BS values along the hyperparameter variation

% ### input:
% - tab: res_tab from compute_bs_ap
% - props: properties struct
% - plot_error: boolean for displaying the std. error

% ### output:
% - creates a new figure

% ### open points: 
% - automate class labeling

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

if length(varargin)>0
    plot_error = varargin{1}; 
else
    plot_error = true; 
end

num_solutions = ((width(tab)-1)/2)-1;

class_names = {props.templ.label{:}, 'NaN'};

figure; 
p = cell(num_solutions, 1);
if plot_error
    for i = 1:num_solutions
        p{i} = errorbar(table2array(tab(:,1)), table2array(tab(:,i+1)), table2array(tab(:, i+2+num_solutions)), ...
            'DisplayName', class_names{i}); hold on; %['class ', num2str(i)]); hold on; 
    end
else
    for i = 1:num_solutions
        p{i} = plot(table2array(tab(:,1)), table2array(tab(:,i+1)), ...
            'DisplayName', class_names{i}, ... %['class ', num2str(i)], ...
            'marker', '.', 'markersize', 10); hold on; 
    end
end
legend([p{:}]);
xlabel(['hyperparameter ', props.ap_study.ap_name], 'interpreter', 'latex'); 
ylabel('basin stability', 'interpreter', 'latex'); 

saveas(gcf,[props.subCasePath,'/fig_hyperparameter_study'], 'png');
savefig(gcf,[props.subCasePath,'/fig_hyperparameter_study']);


end

