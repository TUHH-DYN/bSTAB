function [dydt] = ode_duffing(t, y, delta, k3, A)
% [dydt] = ode_duffing(t, y, delta, k3, A)

% ODE definition of the Duffing oscillator.
% parameter choice for 5 multistability:
% delta = 0.08; k3 = 1; A = 0.2

% Following 
% Thomson & Steward: Nonlinear Dynamics and Chaos. Page 9, Fig. 1.9.

dydt = [ y(2); 
    -delta*y(2)-k3*y(1)^3+A*cos(t)]; 

end

