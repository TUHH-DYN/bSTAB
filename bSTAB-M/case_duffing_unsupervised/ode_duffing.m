function [dydt] = ode_duffing(t, y, delta, k3, A)
% [dydt] = ode_duffing(t, y, delta, k3, A)

% ODE definition of the Duffing oscillator.
% parameter choice for 5 multistability:
% delta = 0.08; k3 = 1; A = 0.2

% Following 
% Thomson & Steward: Nonlinear Dynamics and Chaos. Page 9, Fig. 1.9.

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

dydt = [ y(2); 
    -delta*y(2)-k3*y(1)^3+A*cos(t)]; 

end

