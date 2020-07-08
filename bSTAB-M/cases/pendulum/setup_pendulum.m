function  [props] = setup_pendulum(props)
% [props] = setup_pendulum(props)

% Define the system, the properties and so on. This will output a struct
% containing all the relevant pieces of information

% ### input:
% - props: properties struct

% ### output:
% - props: updated struct, including all the model parameters

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
props.model.ode_fun = @ode_pendulum; % a function handle @my_ode_function

% 1.3 define the optional parameters that the ODE definition requires (in the
% correct order as requested by ode_function)
% Eaxmple: [dydt] = my_ode_function(t,y, p1, p2, p3)
alpha = 0.1;    % p1
T = 0.5;        % p2
K = 1;          % p3

% 1.4 constitute the parameter vector that will be handled to the ode function
props.model.ode_params = [alpha, T, K];


%% 2. define possible solutions of the system
% tell the program which solutions are possible, and what characteristics
% they have. We need a 'ground truth' for classifying new data. Here, you
% simply supply initial conditions per solution, i.e. you need to know at
% just one initial condition for each steady-state. We will automatically
% create the corresponding feature vector (class template) that will be
% used by the classifier to assign a label to a new time integration result

% the number of different steady-state solutions
props.templates.num_solutions = 2;

% we use cells to store the initial conditions and the label for each
% steady-state solution

% the initial condition that leads the system to end up on the first steady state
props.templates.Y0{1} = [0.5; 0];   % initial condition (NOT the steady-state itself)
props.templates.label{1} = 'FP';    % stable fixed point label

% the initial condition that leads the system to end up on the second stable steady state
props.templates.Y0{2} = [2.7; 0];
props.templates.label{2} = 'LC'; % limit cycle solution label


%% 3. time integration parameters
% set the time integration time span, resolution, tolerances, etc.

% 3.1 sampling frequency fs = 1/dt
props.ti.fs = 20;

% 3.2 time span for the time integration
props.ti.t_end = 500; 
props.ti.t_span = [0:1/props.ti.fs:props.ti.t_end];

% 3.3 steady-state time. The system should have arrived at a steady-state
% after this point to avoid issues stemming from transients. All data after
% this point in time will be used to classify the steady-state into one of
% the possible solutions of the system
props.ti.t_star = props.ti.t_span(end)-50;

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
props.bs.n_points = 1000;

% 4.2 range of region of interest

% [min. val state 1; min. val state 2; ...]
props.bs.Y0_min_vals = [-pi+asin(T/K), -10];

% [max. val state 1; max. val state 2; ...]
props.bs.Y0_max_vals = [pi+asin(T/K), 5];

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
props.bs.feat_extract_fun = @extract_features_pendulum; % a function handle

% 4.5 classification function options. Please indicate the classification
% function. Per default, we use a simple Euclidean distance classifier #
% with some prescribed tolerance you may add additional parameters here if
% required.
props.bs.class_tol = 2e-02;


% save all these properties to the sub-case folder. Just in case that you
% want to access the properties later on
save([props.sub_case_path, '/props_initial.mat'], 'props');

end

