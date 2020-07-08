function [dydt] = ode_duffing(t, y, c, k, k3, B, omega)
% [dydt] = ode_duffing(t, y, c, k, k3, B, omega)
% ODE definition of the Duffing oscillator


% ### input:
% - parameters of the duffing oscillator

% ### output:
% - derivative of the state space vector

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


dydt = [y(2); 
        -c*y(2)-k*y(1)-k3*y(1).^3+B*cos(omega*t)];


end
