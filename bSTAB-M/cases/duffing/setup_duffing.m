function  [props] = setup_duffing(props)
% [props] = setup_duffing(props)

% Following 
% Thomson & Steward: Nonlinear Dynamics and Chaos. Page 9, Fig. 1.9.


% ### input:
% - props

% ### output:
% - props

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

%% 0. general settings

% parallel properties
props.flag_par = true; 

% visual output of the program
props.flag_plotting = true; 


%% 1. dynamical system properties
% we will store all the relevant properties in props.model.

% 1.1 define the system properties
props.model.dof = 2; % degrees-of-freedom (= length of state vector)

% 1.2 define the system definition Matlab file
props.model.ode_fun = @ode_duffing; % a function handle @my_ode_function

% 1.3 define the optional parameters that the ODE definition requires (in the
% correct order as requested by ode_function)
c = 0.08; 
k = 0; 
k3 = 1; 
B = 0.2; 
omega = 1; 

% 1.4 constitute the parameter vector that will be handled to the ode function
props.model.ode_params = [c, k, k3, B, omega]; 


%% 2. define possible solutions of the system
% tell the program which solutions are possible, and what characteristics
% they have. We need a 'ground truth' for classifying new data. Here, you
% simply supply initial conditions per solution, i.e. you need to know at
% just one initial condition for each steady-state. We will automatically
% create the corresponding feature vector (class template) that will be 
% used by the classifier to assign a label to a new time integration result

% the number of different steady-state solutions
props.templates.num_solutions = 5;

% the initial condition that leads the system to end up on the first steady state
props.templates.Y0{1} = [-0.21; 0.02]; 
props.templates.label{1} = 'a1';    % small n=1 cycle

props.templates.Y0{2} = [1.05; 0.77]; 
props.templates.label{2} = 'a2';    % large n=1 cycle

props.templates.Y0{3} = [-0.67; 0.02]; 
props.templates.label{3} = 'a3';    % first n=2 cycle

props.templates.Y0{4} = [-0.46; 0.30]; 
props.templates.label{4} = 'a4';    % second n=2 cycle

props.templates.Y0{5} = [-0.43; 0.12]; 
props.templates.label{5} = 'a5';    % n=3 cycle


%% 3. time integration parameters
% set the time integration time span, resolution, tolerances, etc.

fs = .5*2*pi; 

% 3.1 sampling frequency fs = 1/dt
props.ti.fs = .5*2*pi; 

% 3.2 time span for the time integration
n_period = 200;
props.ti.t_span = [0:1/fs:n_period*2*pi];

% 3.3 steady-state time. The system should have arrived at a steady-state 
% after this point to avoid issues stemming from transients. All data after
% this point in time will be used to classify the steady-state into one of 
% the possible solutions of the system
props.ti.t_star = props.ti.t_span(end)-50*2*pi;

% 3.4 time_integrator method. Check 
% https://de.mathworks.com/help/matlab/math/choose-an-ode-solver.html
% for further advice, e.g. ode23t for vanishing numerical damping
props.ti.time_stepper = 'ode45';

% 3.5 time integration options. use the odeset() functionalities
options = odeset('RelTol',1e-8);
props.ti.options = options;


%% 4. basin stability parameters
% parameters specific to the basin stability computation (sampling etc.)

% 4.1 number of initial conditions in total
props.bs.n_points = 5000;

% 4.2 range of region of interest

% [min. val state 1; min. val state 2; ...]
props.bs.Y0_min_vals = [-0.8, -0.4];  

% [max. val state 1; max. val state 2; ...]
props.bs.Y0_max_vals = [1.2, 1.0]; 

% 4.3 sampling strategy. 
% possible candidates (see documentation for more details)
% - 'uniform': uniform distribution at random (default!)
% - 'multGauss': multivariate, independent Gaussians
% - 'grid': linearly spaced grid
% - 'custom': provide your own set of initial conditions
props.bs.sampling_mode = 'uniform';

% 4.4 feature extractor function provided by the user. 
% Please indicate the function that derives descriptive features from the 
% time integrations. The features will be used to classify the steady-state 
% into the given possibilities.
props.bs.feat_extract_fun = @extract_features_duffing; % a function handle

% 4.5 classification function options. Please indicate the classification 
% function. Per default, we use a simple Euclidean distance classifier #
% with some prescribed tolerance you may add additional parameters here if 
% required.
props.bs.class_tol = 5e-01;


% save all these properties to the sub-case folder. Just in case that you
% want to access the properties later on
save([props.sub_case_path, '/props.mat'], 'props'); 
end

