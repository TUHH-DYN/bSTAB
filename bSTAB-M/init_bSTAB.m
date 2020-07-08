function [props] = init_bSTAB(case_path, sub_case_path)
% [props] = init_bSTAB(case_path, sub_case_path)

% initializer of the bSTAB library. Adds local routines to the Matlab
% search path, and creates the <props> struct that will carry all relevant
% properties and settings through the computations.

% ### input:
% - case_path: path to system definition file
% - sub_case_path: local subdirectory for current study

% ### output:
% - props: properties struct

% ### open points: 
% - default inputs, such that the user does not have to specify
% anything as input. if no sub-case was specified: make up some data-time 
% string to create a distinct folder

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


% 1. add the library to the active Matlab path
addpath(genpath('../../utils'));  % bSTAB utilities

% 2. add your custom case to the active Matlab path
addpath(case_path); % place all your custom functions here

% 3. create a subfolder for the current analysis
mkdir([case_path, '/', sub_case_path]); 
addpath([case_path, '/', sub_case_path]);

% 4. initialize the props struct that will be the anchor of the calculation
props.case_path = case_path;
props.sub_case_path = [case_path, '/', sub_case_path];

end

