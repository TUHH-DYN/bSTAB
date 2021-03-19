function  [props] = setup_duffing(props)
% [props] = setup_duffing(props)

% Define the dynamical system, the model parameters, and all hyper
% parmaeters and properties required for the basin stability computation.

% This will function returns a structure array (struct) 'props'
% containing all the relevant pieces of information for easy handling and
% storing.

% 18.03.2021
% -------------------------------------------------------------------------
% Copyright (C) 2020 Merten Stender (m.stender@tuhh.de)
% Hamburg University of Technology, Dynamics Group, www.tuhh.de/dyn

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

%% 0. general program settings
% appearance, parallelization options

% parallel properties: usage of multiple cores
props.flagParallel = true;

% visual output of the program during computation
props.flagShowFigures = true;

% disable all graphical feedback for HPC deployment
props.flagUseHPC = false;

% show progress bar along computation (requires the ParforProgressbar tool)
props.progessBar = true;


%% 1. dynamical system properties (.model struct)
% we will store all the relevant properties in props.model.

% 1.1 define the system definition Matlab file
props.model.odeFun = @ode_duffing; % a function handle @my_ode_function

% 1.2 define the state space dimension D
props.model.dof = 2; % degrees-of-freedom (= length of state vector)

% 1.3 define the optional parameters that the ODE definition requires (in the
% correct order as requested by ode_function)
% Eaxmple: [dydt] = my_ode_function(t,y, p1, p2, p3)
delta = 0.08;    % p1
k3 = 1.0;        % p2
A = 0.2;          % p3

% constitute the parameter vector that will be handled to the ode function
props.model.odeParams = [delta, k3, A];


%% 2. Region of Interest (.roi struct)
% Specify the subset of the state space where to sample the states from

% 2.1 number of samples N
props.roi.N = 2000; % integer number

% 2.2 minima (per state space dimension)
props.roi.minLimits = [-1.0, -0.5]; % must be of length <props.model.dof>

% 2.3 maxima (per state space dimension)
props.roi.maxLimits = [1.0, 1.0]; % must be of length <props.model.dof>

% 2.4 select dimensions for which to create sampling points (some
% dimensions may be excluded from the sampling through this selection)
props.bs.samplingVarDims = [true; true]; % boolean: dims to vary

% 2.5 sampling strategy / probability density function rho
% possible candidates (see documentation for more details)
% - 'uniform': uniform distribution at random (default!)
% - 'multGauss': multivariate, independent Gaussians
% - 'grid': linearly spaced grid
% - 'custom': provide your own set of initial conditions per .samplingCustomPDF
props.roi.samplingPDF = 'uniform';

% 2.6 if a custom PDF is chosen: specify function handle
% must take as inputs: fun(N, minLimits, maxLimits, samplingVarDims)
% must return as output: array of initial conditions
props.bs.samplingCustomFun = ''; % a function handle @


%% 3. Time integration parameters (.ti struct)
% specify time stepping routine, its hyperparameters, etc.

% 3.1 sampling frequency fs = 1/dt for the time stepper
props.ti.fs = 50;

% 3.2 time span for the time integration
props.ti.tSpanStart = 0;
props.ti.tSpanEnd = 1000;
props.ti.tSpan = [props.ti.tSpanStart props.ti.tSpanEnd];

% 3.3 steady-state time. The system should have arrived at a steady-state
% after this point to avoid issues stemming from transients. All data after
% this point in time will be used to classify the steady-state into one of
% the possible solutions of the system
props.ti.tStar = props.ti.tSpan(end)-100;

% 3.4 time_integrator method. Check
% https://de.mathworks.com/help/matlab/math/choose-an-ode-solver.html
% for further advice, e.g. ode23t for vanishing numerical damping
props.ti.timeStepper = 'ode45';

% 3.5 time integration options. use the odeset() functionalities
% options = odeset('RelTol',1e-8);
% options = odeset('RelTol',1e-6,'AbsTol',1e-8,'InitialStep',5e-3);
options = odeset('RelTol',1e-8);
props.ti.options = options;

%% 4. Clustering options (.clust struct)
% parameters of the trajectory classification task

% 4.1. clustering mode (supervised / unsupervised)
% if 'supervised': the user has to specify templates for each solution in
% the following section 5.
% if 'unsupervised': the trajectories will be clustered without specifying
% the number of clusters
props.clust.clustMode = 'unsupervised'; % string

% 4.2 feature extractor function provided by the user.
% Please indicate the function that derives descriptive features from the
% time integrations. The features will be used to classify the steady-state
% solutions into k classes / clusters
props.clust.featExtractFun = @features_duffing; % a function handle

% 4.3 number of extracted features
props.clust.numFeatures = 2;

% 4.4. further clustering options
% Please indicate the classification function. Per default, we use a simple
% Euclidean distance classifier with some prescribed tolerance. You may add
% additional parameters here if required.
% clustering methods (supervised):
% - kNN (k=1), default choice
% - kNN_thresholded (k=1), maximum distance prescribed
props.clust.clustMethod = 'kNN'; % default: kNN(k=1) using Euclidean distance

% clustering method: distance norm (supervised case using Statistics and ML
% toolbox). possible choices: 'euclidean' (default), 'seuclidean',
% 'cityblock', 'chebychev', 'minkowski', 'mahalanobis', 'cosine',
% 'correlation', 'spearman', 'hamming', 'jaccard'
props.clust.clustMethodNorm = 'euclidean';

% distance threshold for kNN_thresholded
props.clust.clustMethodTol = NaN;


%% 5. Templates (for the supervised clustering setting)
% tell the program which solutions are possible, and what characteristics
% they have. We need a 'ground truth' for classifying new data. Here, you
% simply supply initial conditions per solution, i.e. you need to know at
% just one initial condition for each steady-state. We will automatically
% create the corresponding feature vector (class template) that will be
% used by the classifier to assign a label to a new time integration result

% ---> we're using the unsupervised setting, nothing to set here!


%% 6. Evaluation
% as we run so many time integrations, it seems natural to collect some
% amplitude values that can visualize a bifurcation map
props.eval.ampFun = @extract_amp_duffing; % a function handle


%% 7. Bug check (to do)
% check the parameters implemented above for consistency, existence of
% functions etc. Return warnings for obvious errors.
props = check_props(props);

%% store the parameters locally to the project subfolder
% save all these properties to the sub-case folder. Just in case that you
% want to access the properties later on
save([props.subCasePath, '/props.mat'], 'props');
end
