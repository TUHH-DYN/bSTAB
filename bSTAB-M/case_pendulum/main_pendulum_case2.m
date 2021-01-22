% main file for computing the basin stability as a function of the driving
% torque T

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
currentCase = 'publication_case2'; 

% set up paths, initialize bSTAB, create properties struct <props>
[props] = init_bSTAB(currentCase);


%% 1. set up your case
% all the properties, options and parameters defined hereafter will be
% assigned to a single struct 'props' that makes the handling easier. You
% will only need to change this file for your indivudual system (and the
% functions referenced herein).
[props] = setup_pendulum(props);


%% 2. compute basin stability along model parameter variation
% we introduce another struct in props: ap_study and specify the
% model parameter and the its variation range here.

% Specify that you want to vary a model parameter
props.ap_study.mode = 'model_parameter'; 

% identify the props struct element that you want to vary. 
props.ap_study.ap = 2;

% specify the parameter variation vector
props.ap_study.ap_values = 0.01:0.05:1.0;

% specify the name of the adaptive parameter (just for plotting purpose)
props.ap_study.ap_name = '$T$'; 

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

% 1. variation of the basin stability value against model parameter
plot_bs_parameter_study(props, res_tab, false); 

% 2. display bifurcation diagram (rather: orbit diagram)
plot_bif_diagram(props, res_detail, [2])


%% Publication case 2: basin stability vs. T

T_grid = 0.005:0.0000001:1.0; 
alpha = 0.1; 
K = 1.0; 

lambda1 = -alpha/2+sqrt((alpha^2-4.*K.*cos(asin(T_grid./K)))./2);
lambda2 = -alpha/2-sqrt((alpha^2-4.*K.*cos(asin(T_grid./K)))./2);

figure; 
plot(T_grid, real(lambda1)); 
saveas(gcf,[props.subCasePath,'/publication_case2_lyapunov'], 'png');
% savefig(gcf,[props.subCasePath,'/publication_case2_lyapunov']);

figure; 
plot(T_grid, real(lambda1)); 
xlim([0.99999, 1.000001])
saveas(gcf,[props.subCasePath,'/publication_case2_lyapunov_zoom'], 'png');
savefig(gcf,[props.subCasePath,'/publication_case2_lyapunov_zoom']);


