% main file for computing the basin stability of the multi-stable (5 limit
% cycles) Duffing oscillator

% Following 
% Thomson & Steward: Nonlinear Dynamics and Chaos. Page 9, Fig. 1.9.

% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% 
% 31.03.2021
% -------------------------------------------------------------------------


% NOTE: <init_bStab> must be located on the active Matlab path!

% ensure a clean start
clear; close all; clc;

% define a name for the current analysis (a subdirectory will be created in
% this folder)
currentCase = 'publication_case_1'; 

% set up paths, initialize bSTAB, create properties struct <props>
[props] = init_bSTAB(currentCase);


%% 1. set up your case
% all the properties, options and parameters defined hereafter will be
% assigned to a single struct 'props' that makes the handling easier. You
% will only need to change this file for your indivudual system (and the
% functions referenced herein).
[props] = setup_duffing(props);

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



%% Publication: state space and steady-state trajectories

% computing the trajectories for all the template solutions provided in the
% setup definition
tspan = [0:1/10:50]; 
options = odeset('RelTol',1e-8);

x01 = props.templ.Y0{1};
p01 = num2cell(props.templ.modelParams{1});
[T1, Y1] = ode45(@(t,y) ode_duffing(t, y, p01{:}), tspan, x01, options);

x02 = props.templ.Y0{2};
p02 = num2cell(props.templ.modelParams{2});
[T2, Y2] = ode45(@(t,y) ode_duffing(t, y, p02{:}), tspan, x02, options);

x03 = props.templ.Y0{3};
p03 = num2cell(props.templ.modelParams{3});
[T3, Y3] = ode45(@(t,y) ode_duffing(t, y, p03{:}), tspan, x03, options);

x04 = props.templ.Y0{4};
p04 = num2cell(props.templ.modelParams{4});
[T4, Y4] = ode45(@(t,y) ode_duffing(t, y, p04{:}), tspan, x04, options);

x05 = props.templ.Y0{5};
p05 = num2cell(props.templ.modelParams{5});
[T5, Y5] = ode45(@(t,y) ode_duffing(t, y, p05{:}), tspan, x05, options);

% time signals
figure; 
ax1 = subplot(5,1,1);
plot(T1, Y1(:,1), 'lineWidth', 2); ylabel('$y_1$', 'interpreter', 'latex');
set(gca, 'xtick', []); title('initial condition $y_{0, 1}$', 'interpreter', 'latex');

ax2 = subplot(5,1,2);
plot(T2, Y2(:,1), 'lineWidth', 2);ylabel('$y_1$', 'interpreter', 'latex');
set(gca, 'xtick', []); title('initial condition $y_{0, 2}$', 'interpreter', 'latex');

ax3 = subplot(5,1,3);
plot(T3, Y3(:,1), 'lineWidth', 2); ylabel('$y_1$', 'interpreter', 'latex');
set(gca, 'xtick', []); title('initial condition $y_{0, 3}$', 'interpreter', 'latex');

ax4 = subplot(5,1,4);
plot(T4, Y4(:,1), 'lineWidth', 2);ylabel('$y_1$', 'interpreter', 'latex');
set(gca, 'xtick', []); title('initial condition $y_{0, 4}$', 'interpreter', 'latex');

ax5 = subplot(5,1,5);
plot(T5, Y5(:,1), 'lineWidth', 2);ylabel('$y_1$', 'interpreter', 'latex');
xlabel('time', 'interpreter', 'latex'); title('initial condition $y_{0, 5}$', 'interpreter', 'latex');
linkaxes([ax1, ax2, ax3, ax4, ax5], 'xy'); 
saveas(gcf,[props.subCasePath,'/publication_trajectories'], 'png');
savefig(gcf,[props.subCasePath,'/publication_trajectories']);


% state space
figure; 
plot(Y1(end-100:end,1), Y1(end-100:end,2), 'lineWidth', 2); hold on;  
plot(Y2(end-100:end,1), Y2(end-100:end,2), 'lineWidth', 2);
plot(Y3(end-200:end,1), Y3(end-200:end,2), 'lineWidth', 2);
plot(Y4(end-200:end,1), Y4(end-200:end,2), 'lineWidth', 2);
plot(Y5(end-300:end,1), Y5(end-300:end,2), 'lineWidth', 2);
l=legend('$\bar{y}_1$', '$\bar{y}_2$', '$\bar{y}_3$', '$\bar{y}_4$', '$\bar{y}_5$');
l.Interpreter = 'Latex';
title('5 co-existing attractors');
xlabel('$y_1$', 'interpreter', 'latex');
ylabel('$y_2$', 'interpreter', 'latex');
saveas(gcf,[props.subCasePath,'/publication_statespace'], 'png');
savefig(gcf,[props.subCasePath,'/publication_statespace']);
