function [T, Y] = run_time_integration(ode_fun, tspan, ic, params, options, time_integrator)
% [T, Y] = run_time_integration(ode_fun, tspan, ic, params, options, time_integrator)

% runs a time integration on the given ODE system and for the specified
% parameters

% input:
% - ode_fun: function handle to the ODE definition
% - tspan: time span for the time integration
% - ic: initial conditions
% - params: additional parameters to be handled to the ODE function
% - options: ode options from the odeset() functionality.
% - time_integrator: ode45, ode23t and so on

% outputs:
% - T: time vector
% - Y: states

% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% -------------------------------------------------------------------------

% we make the parametes a cell for easier handling in the function call
params = num2cell(params);

% run the time integration.
switch time_integrator
    case 'ode45'
        [T,Y] = ode45(@(t,y) ode_fun(t,y, params{:}), tspan, ic, options);
        
    case 'ode23'
        [T,Y] = ode23(@(t,y) ode_fun(t,y, params{:}), tspan, ic, options);
        
    case 'ode113'
        [T,Y] = ode113(@(t,y) ode_fun(t,y, params{:}), tspan, ic, options);
        
    case 'ode15s'
        [T,Y] = ode15s(@(t,y) ode_fun(t,y, params{:}), tspan, ic, options);
        
    case 'ode23s'
        [T,Y] = ode23s(@(t,y) ode_fun(t,y, params{:}), tspan, ic, options);
        
    case 'ode23t'
        [T,Y] = ode23t(@(t,y) ode_fun(t,y, params{:}), tspan, ic, options);
        
    case 'ode23tb'
        [T,Y] = ode23tb(@(t,y) ode_fun(t,y, params{:}), tspan, ic, options);
        
    case 'ode15i'
        [T,Y] = ode15i(@(t,y) ode_fun(t,y, params{:}), tspan, ic, options);
        
    otherwise
        error('sorry, this time integrator is not valid');
end

% just for debugging
% figure; 
% plot(T, Y(:, 1:2)); 
% xlabel('time');
% close(gcf);

end

