function unit_tests
% run all cases currently implemented

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

addpath('..'); 

%% Duffing oscillator (supervised case)

addpath('../case_duffing/'); 
cd('../case_duffing/'); % cd into case
main_duffing; 
close all; 
disp('Duffing case test successful!');
cd('../utils_bSTAB/'); % cd back into utils
rmpath('../case_duffing/'); 


%% Duffing oscillator (unsupervised case)

addpath('../case_duffing_unsupervised/'); 
cd('../case_duffing_unsupervised/'); % cd into case
main_duffing_unsupervised; 
close all; 
disp('Duffing unsupervised case test successful!');
cd('../utils_bSTAB/'); % cd back into utils
rmpath('../case_duffing_unsupervised/'); 


%% Friction oscillator

addpath('../case_friction/'); 
cd('../case_friction/'); % cd into case
main_friction; 
close all; 

main_friction_vStudy; 
close all;

disp('Duffing unsupervised case test successful!');
cd('../utils_bSTAB/'); % cd back into utils
rmpath('../case_friction/'); 


%% Lorenz system

addpath('../case_lorenz/'); 
cd('../case_lorenz/'); % cd into case
main_lorenz; 
close all; 

main_lorenz_hyperpN; 
close all; 

main_lorenz_hyperpTol; 
close all; 

main_lorenz_sigmaStudy; 
close all; 

disp('Duffing unsupervised case test successful!');
cd('../utils_bSTAB/'); % cd back into utils
rmpath('../case_lorenz/'); 


%% Pendulum

addpath('../case_fpendulum/'); 
cd('../case_pendulum/'); % cd into case
main_pendulum_case1; 
close all; 

main_pendulum_case2; 
close all; 

main_pendulum_hyperparameters; 
close all; 

disp('Duffing unsupervised case test successful!');
cd('../utils_bSTAB/'); % cd back into utils
rmpath('../case_pendulum/'); 

end

