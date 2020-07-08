% Script for studying the basin stability as a function of one of the
% model's parameters

% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% -------------------------------------------------------------------------

% ensure a clean start
clear; close all; clc;
addpath('../../'); % add the main directory to the matlab active path

% path to your project
case_path = pwd; 
sub_case_path = 'T_study'; 

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

%% 2. specify the model parameter that you want to vary

% adaptive parameter study mode. Specify that you want to vary a model
% parameter
props.ap_study.mode = 'model_parameter'; 

% identify the position of the adaptive parameter in the model parameter
% vector props.model.ode_params. E.g. if you want to change the first
% parameter, you will set ap = 1
% here, T is the second parameter in the model setup [alpha, T, K]
props.ap_study.ap = 2; 

% specify the parameter variation vector
props.ap_study.ap_values = linspace(0.01, 1, 10);

% specify the name of the adaptive parameter (just for plotting purpose)
props.ap_study.ap_name = '$T$'; 


%% 3. compute the basin stability for the parameter variations

% compute the BS for various configurations of the case
[res_tab, res_detail, props] = compute_bs_ap(props);


%% 4. plot the results

% plot the results
plot_parameter_study(res_tab, props, true)
saveas(gcf,[props.sub_case_path,'/fig_T_study'], 'png');
savefig(gcf,[props.sub_case_path,'/fig_T_study']);
export2tikz([props.sub_case_path,'/fig_T_study'], 8, 8); 
