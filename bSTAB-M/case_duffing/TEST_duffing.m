% test your custom model by running this code from the local folder, 
% i.e. from bSTAB-M/yourFolder/
% You only need to adapt line 10 and put in your own setup file name

addpath('..\utils_bSTAB');

%% 1. try to run a single time integration (avoid mistakes with the ode definition)

% get model parameters from the setup
[props] = setup_duffing(props);  % <------- put in your own case definition!

% run a simple time integration
y0 = [props.roi.maxLimits];         % select the max limits as initial conditions
tspan = [props.ti.tSpan];           % time span to run the integration
ode_fun = props.model.odeFun;       % ODE function to integrate
params = num2cell(props.model.odeParams);   % model parameters, use a cell array to handle them to the integrator

% run a time integration
[T,Y] = ode45(@(t,y) ode_fun(t,y, params{:}), tspan, y0);

figure(); 
plot(T, Y); 
xlabel('time'); ylabel('state'); title('a single time integration');


%% 2. try to run some time integration from the range of initial conditions

[IC] = generate_ic_grid(props);  % generate the set of initial conditions

figure();
for i = 1:min([50, props.roi.N])
    [T,Y] = ode45(@(t,y) ode_fun(t,y, params{:}), tspan, IC(i,:));
    plot(T, Y(:,1)); hold on; 
end
xlabel('time'); ylabel('state 1'); title('some realizations from the ROI');
