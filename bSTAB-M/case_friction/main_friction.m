% main file for computing the basin stability of the multi-stable Lorenz
% system following: 

% https://doi.org/10.1142/S0218127414501314)
% Chunbiao Li and Julien Clinton Sprott
% "Multistability in the Lorenz System: A Broken Butterfly"

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
addpath('../');

% define a name for the current analysis (a subdirectory will be created in
% this folder)
currentCase = 'grid'; 

% set up paths, initialize bSTAB, create properties struct <props>
[props] = init_bSTAB(currentCase);


%% 1. set up your case
% all the properties, options and parameters defined hereafter will be
% assigned to a single struct 'props' that makes the handling easier. You
% will only need to change this file for your indivudual system (and the
% functions referenced herein).
[props] = setup_friction(props);

% if you quickly want to update model parameters, you can change them via
props.model.odeParams = [1.5]; 


%% 2. compute the basin stability

% let bSTAB compute the basin stability values
[res_tab, res_detail, props] = compute_bs(props);

% save the results (the compuatation may have took quite a long time, so 
% make sure to not lose the data!)
save([props.subCasePath, '/results.mat']);


%% 3. plot the results
% we provide some basic plotting functionalities. Individual elements must 
% be fine-tuned by the user upon creating final figures (axis labels etc.).
% This can be done by adding another struct to <props>, and then adapting
% the plotting functions to take the struct entries and integrate them into
% the figures.

% clear; close all; clc; 
% 
% load('case_1\props.mat'); 
% load('case_1\results.mat');
% 
% props.subCasePath = 'case_1';

% 1. bar plot for the basin stability values
plot_bs_bargraph(props, res_tab, true); 

% 2. state space scatter plot: class-labeled initial conditions
plot_bs_statespace(props, res_detail, 1, 2);

% 3. feature space and classifier results
plot_bs_featurespace(props, res_detail);



%% Publication: state space and steady-state trajectories

% saveas(gcf,[props.subCasePath,'/publication_trajectories'], 'png');
% savefig(gcf,[props.subCasePath,'/publication_trajectories']);

% stick-slip limit cycle
vd = 1.5; 
tspan = [0:1/50:20];
y0 = [2,2]; 

options = odeset('RelTol',1e-8);
[T0, Y0] = ode45(@(t,y) ode_friction(t, y, vd), tspan, y0, options);

idx = find(T0>13.5); 
T = T0(idx:end); 
Y = Y0(idx:end,:);

hold on;
plot(Y(:,1), Y(:,2)); hold on; 
plot(0.5, 0, '.', 'markerSize', 10); 
