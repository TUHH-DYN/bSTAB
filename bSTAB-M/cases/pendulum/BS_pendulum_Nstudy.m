% Script for studying the basin stability as a function of one of the
% method's hyperparameters

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
sub_case_path = 'N_study'; 

% initialize bSTAB and the case settings
[props] = init_bSTAB(case_path, sub_case_path);

% % use profiling to find the computational bottlenecks
% profile on

%% 1. set up your case

% all the properties, options and parameters defined hereafter will be
% assigned to a single struct 'props' that makes the handling easier. You
% will only need to change this file for your indivudual system (and the
% functions referenced herein).
[props] = setup_pendulum(props);

%% 2. specify the hyperparameter that you want to study

% adaptive parameter study mode. Specify that you want to vary a model
% hyperparameter
props.ap_study.mode = 'hyper_parameter'; 

% name of the hyperparameter inside the props struct (possibly including
% sub-field names
props.ap_study.ap = 'bs.n_points'; 

% specify the parameter variation vector
props.ap_study.ap_values = 0.5.*logspace(1, 3, 10);

% specify the name of the adaptive parameter (just for plotting purpose)
props.ap_study.ap_name = '$n$'; 


%% 3. compute the basin stability for the parameter variations

% compute the BS for various configurations of the case
[res_tab, res_detail, props] = compute_bs_ap(props);

% save the results first, then post-process all the numbers
save([props.sub_case_path, '/results_ap_study.mat']);

%% 4. plot the results

% plot the results
plot_hyperp_study(res_tab, props, true); 
saveas(gcf,[props.sub_case_path,'/fig_parameter_study'], 'png');
savefig(gcf,[props.sub_case_path,'/fig_parameter_study']);


