% main file for computing the basin stability of a nonlinear dynamical
% system that features multiple solutions

% Following 
% Thomson & Steward: Nonlinear Dynamics and Chaos. Page 9, Fig. 1.9.

% ### input:
% - 

% ### output:
% - 

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

% ensure a clean start
clear; close all; clc;
addpath('../../'); % add the main directory to the matlab active path

% path to your project
case_path = pwd; 
sub_case_path = 'midscale_N5000'; 

% initialize bSTAB and the case settings
[props] = init_bSTAB(case_path, sub_case_path);

% % use profiling to find the computational bottlenecks
% profile on

%% 1. set up your case

% all the properties, options and parameters defined hereafter will be
% assigned to a single struct 'props' that makes the handling easier. You
% will only need to change this file for your indivudual system (and the
% functions referenced herein).
[props] = setup_duffing(props);


%% 2. compute the basin stability

% generate the ground truth labels for each class of solutions
[props] = generate_feature_templates(props);

% now compute the basin stability values
[res_tab, res_detail, props] = compute_bs(props);

% save the results (it may have took quite a long time, so make sure to not
% lose the data
save([props.sub_case_path, '/results_basinstability.mat']);

% % display the profiling results
% profile viewer

for i = 1:height(res_tab)
   disp(['basin stability of solution ', num2str(i), ', label: ', char(res_tab.label(i)), ' : S=', num2str(res_tab.basinStability(i))]); 
end


%% 3. plot the results

% 1. bar plot for the basin stability values
plot_bs_bar(res_tab, false)
saveas(gcf,[props.sub_case_path,'/fig_basinstability'], 'png');
savefig(gcf,[props.sub_case_path,'/fig_basinstability']);
export2tikz([props.sub_case_path,'/fig_basinstability'], 4, 4); 

% 2. state space with class-labeled initial conditions
plot_statespace(res_detail, 1, 2)
saveas(gcf,[props.sub_case_path,'/fig_statespace'], 'png');
savefig(gcf,[props.sub_case_path,'/fig_statespace']);
export2tikz([props.sub_case_path,'/fig_statespace'], 8, 8); 

% feature space and classifier results
plot_feature_space(res_detail)
saveas(gcf,[props.sub_case_path,'/fig_featurespace'], 'png');
savefig(gcf,[props.sub_case_path,'/fig_featurespace']);
export2tikz([props.sub_case_path,'/fig_featurespace'], 8, 8); 


%% time integration results (attractors in phase space)

% plot the last <idx> points later
idx = 2000; 
t_span = [0:1/100:500];

% a) first attractor (small period-1 LC)
par = num2cell(props.model.ode_params); 
[T,Y] = ode23t(@(t,y) props.model.ode_fun(t,y, par{:}), t_span, props.templates.Y0{1}, props.ti.options);
y1 = Y(end-idx:end,:);

% b) second attractor (large period-1 LC)
par = num2cell(props.model.ode_params); 
[T,Y] = ode23t(@(t,y) props.model.ode_fun(t,y, par{:}), t_span, props.templates.Y0{2}, props.ti.options);
y2 = Y(end-idx:end,:);

% c) third attractor (1st period-2 LC)
par = num2cell(props.model.ode_params); 
[T,Y] = ode23t(@(t,y) props.model.ode_fun(t,y, par{:}), t_span, props.templates.Y0{3}, props.ti.options);
y3 = Y(end-idx:end,:);

% d) fourth attractor (2nd period-2 LC)
par = num2cell(props.model.ode_params); 
[T,Y] = ode23t(@(t,y) props.model.ode_fun(t,y, par{:}), t_span, props.templates.Y0{4}, props.ti.options);
y4 = Y(end-idx:end,:);

% e) fivth attractor (period-3 LC)
par = num2cell(props.model.ode_params); 
[T,Y] = ode23t(@(t,y) props.model.ode_fun(t,y, par{:}), t_span, props.templates.Y0{5}, props.ti.options);
y5 = Y(end-idx:end,:);


figure; 
plot(y1(:,1), y1(:,2)); hold on; 
plot(y2(:,1), y2(:,2));
plot(y3(:,1), y3(:,2));
plot(y4(:,1), y4(:,2));
plot(y5(:,1), y5(:,2));
l = legend('1st LC: period-1', ...
    '2nd LC: period-1', ...
    '3rd LC: period-2', ...
    '4th LC: period-2',...
    '5th LC: period-3');
l.Location = 'north';
l.Orientation = 'horizontal';
xlabel('$x$', 'interpreter', 'latex'); ylabel('$\dot{x}$', 'interpreter', 'latex');
saveas(gcf, [props.sub_case_path,'/fig_attractors'], 'png');
savefig(gcf, [props.sub_case_path,'/fig_attractors']);
export2tikz([props.sub_case_path,'/fig_attractors'], 4,4, 80);
