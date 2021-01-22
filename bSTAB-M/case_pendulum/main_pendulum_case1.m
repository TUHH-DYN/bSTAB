% main file for computing the basin stability of the damped driven pendulum

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
currentCase = 'case_1'; 

% set up paths, initialize bSTAB, create properties struct <props>
[props] = init_bSTAB(currentCase);


%% 1. set up your case
% all the properties, options and parameters defined hereafter will be
% assigned to a single struct 'props' that makes the handling easier. You
% will only need to change this file for your indivudual system (and the
% functions referenced herein).
[props] = setup_pendulum(props);

% if you quickly want to update model parameters, you can change them via
% props.model.odeParams = []; here


%% 2. compute the basin stability

% let bSTAB compute the basin stability values
[res_tab, res_detail, props] = compute_bs(props);

% save the results (the compuatation may have took quite a long time, so 
% make sure to not lose the data!)
save([props.subCasePath, '/results_basinstability.mat']);


%% 3. plot the results
% we provide some basic plotting functionalities. Individual elements must 
% be fine-tuned by the user upon creating final figures (axis labels etc.).
% This can be done by adding another struct to <props>, and then adapting
% the plotting functions to take the struct entries and integrate them into
% the figures.

% 1. bar plot for the basin stability values
plot_bs_bargraph(props, res_tab, true); 

% 2. state space scatter plot: class-labeled initial conditions
plot_bs_statespace(props, res_detail, 1, 2);

% 3. feature space and classifier results
plot_bs_featurespace(props, res_detail);



%% Publication case 1: basin stability at fixed parameters

tspan = [0, 30*pi]; 
options = odeset('RelTol',1e-8);

% y1: fixed point solution
x0 = [0.1; 0.1];
[T_fp, Y_fp] = ode45(@(t,y) ode_pendulum(t, y, 0.1, 0.5, 1.0), tspan, x0, options);

% y3: limit cycle solution
K = 1; 
x0 = [pi-asin(0.5/K); 0.1];
[T_lc, Y_lc] = ode45(@(t,y) ode_pendulum(t, y, 0.1, 0.5, 1.0), tspan, x0, options);

figure; 
plot(T_fp, Y_fp(:,2), 'lineWidth', 2); hold on; 
plot(T_lc, Y_lc(:,2), 'lineWidth', 2);
set(gca, 'Xtick', [0, 10*pi, 20*pi, 30*pi]);
set(gca, 'Xticklabel', {'0', '10\pi', '20\pi', '30\pi'});
set(gca, 'Ytick', [0, 2.5, 0.5/alpha]);
set(gca, 'Yticklabel', {'0', 'T/2\alpha', 'T/\alpha'});
ylabel('$y_2$', 'interpreter', 'latex'); 
xlabel('time', 'interpreter', 'latex'); 
saveas(gcf,[props.subCasePath,'/publication_case1'], 'png');
savefig(gcf,[props.subCasePath,'/publication_case1']);



