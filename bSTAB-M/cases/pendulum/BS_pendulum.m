% Script for computing the basin stability of a nonlinear dynamical
% system that features multiple solutions. Case: driven damped pendulum

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
sub_case_path = 'test'; 

% initialize bSTAB and the case settings
[props] = init_bSTAB(case_path, sub_case_path);

% use profiling to find the computational bottlenecks
% profile on

%% 1. set up your case

% all the properties, options and parameters defined hereafter will be
% assigned to a single struct 'props' that makes the handling easier. You
% will only need to change this file for your indivudual system (and the
% functions referenced herein).
[props] = setup_pendulum(props);


%% 2. compute the basin stability

% generate the ground truth labels for each class of solutions
[props] = generate_feature_templates(props);

% now compute the basin stability values
[res_tab, res_detail, props] = compute_bs(props);

% save the results (it may have took quite a long time, so make sure to not
% lose the data before your start plotting and playing around)
save([props.sub_case_path, '/results.mat']);

% display the profiling results
% profile viewer


%% 3. plot the results

% 1. bar plot for the basin stability values
plot_bs_bar(res_tab, false)
saveas(gcf,[props.sub_case_path,'/fig_basinstability_pendulum'], 'png');
savefig(gcf,[props.sub_case_path,'/fig_basinstability_pendulum']);
export2tikz([props.sub_case_path,'/fig_basinstability_pendulum'], 4, 4); 

% 2. state space with class-labeled initial conditions
plot_statespace(res_detail, 1, 2)
saveas(gcf,[props.sub_case_path,'/fig_statespace_pendulum'], 'png');
savefig(gcf,[props.sub_case_path,'/fig_statespace_pendulum']);
export2tikz([props.sub_case_path,'/fig_statespace_pendulum'], 8, 8); 

% feature space and classifier results
plot_feature_space(res_detail)
saveas(gcf,[props.sub_case_path,'/fig_featurespace_pendulum'], 'png');
savefig(gcf,[props.sub_case_path,'/fig_featurespace_pendulum']);
export2tikz([props.sub_case_path,'/fig_featurespace_pendulum'], 8, 8); 



