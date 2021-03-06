% main file for computing the sensitivity of the basin stability values
% against the choice of the hyperparameters

% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% 
% 08.01.2021
% -------------------------------------------------------------------------


% NOTE: <init_bStab> must be located on the active Matlab path!

% ensure a clean start
clear; close all; clc;

% define a name for the current analysis (a subdirectory will be created in
% this folder)
currentCase = 'hyperparameter_N'; 

% set up paths, initialize bSTAB, create properties struct <props>
[props] = init_bSTAB(currentCase);


%% 1. set up your case
% all the properties, options and parameters defined hereafter will be
% assigned to a single struct 'props' that makes the handling easier. You
% will only need to change this file for your indivudual system (and the
% functions referenced herein).
[props] = setup_pendulum(props);


%% 2. compute hyperparameter variation and basin stability sensitivity
% we introduce another struct in props: ap_study and specify the
% hyperparameter and the parameter variation range here. Typically, the
% number of sampling points (props.roi.N), the time span length
% (props.ti.tSpanEnd) and ode integration tolerances are candidates 
% interesting to vary.

% adaptive parameter study mode. Specify that you want to vary a hyper
% parameter
props.ap_study.mode = 'hyper_parameter'; 

% identify the props struct element that you want to vary. 
props.ap_study.ap = 'roi.N';

% specify the parameter variation vector
props.ap_study.ap_values = 5*logspace(1, 3, 20);

% specify the name of the adaptive parameter (just for plotting purpose)
props.ap_study.ap_name = '$N$'; 

% let bSTAB compute basin stability sensitivity
[res_tab, res_detail, props] = compute_bs_ap(props);

% save the results (the compuatation may have took quite a long time, so 
% make sure to not lose the data!)
save([props.subCasePath, '/results.mat']);


%% 3. plot the results
% we provide some basic plotting functionalities. Individual elements must 
% be fine-tuned by the user upon creating final figures (axis labels etc.).
% This can be done by adding another struct to <props>, and then adapting
% the plotting functions to take the struct entries and integrate them into
% the figures.

% 1. variation of the basin stability value against the hyperparameter
% variation
plot_bs_hyperparameter_study(props, res_tab, false); 





