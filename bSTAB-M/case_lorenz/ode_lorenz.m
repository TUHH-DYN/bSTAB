function dydt = ode_lorenz(t, y, sigma, r, b)
% dydt = ode_orenz(t, y, sigma, r, b)

% Definition of the Lorenz system

% classical parameter choice: 
% sigma = 10; 
% r = 28; 
% b = 8/3; 

% --- For the broken butterfly (following
% https://doi.org/10.1142/S0218127414501314)
% Chunbiao Li and Julien Clinton Sprott
% "Multistability in the Lorenz System: A Broken Butterfly"

% sigma = 0.12
% r = 0
% b = -0.6



dydt = [sigma*(y(2)-y(1)); ...
r*y(1)-y(1)*y(3)-y(2); ...
y(1)*y(2) - b*y(3)];

end