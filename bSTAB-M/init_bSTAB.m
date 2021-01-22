function [props] = init_bSTAB(varargin)
% [props] = init_bSTAB(subCase_path)

% initializer for the active Matlab paths, relevant directory paths and the
% properties struct

% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% 
% 08.01.2021
% -------------------------------------------------------------------------


% todo: default inputs, such that the user does not have to specify
% anything as input


% if no sub-case was specified: make up some data-time string to create a
% distinct folder
if length(varargin)>0
    subCasePath = varargin{1}; 
else
    subCasePath = ['analysis_', date];
end

% 1. get current directory (which we assume to be one level lower than the 
% bSTAB toolbox:
% ./<currentCase>/      <--- we're calling from here
% ./init_bSTAB.m        <--- this function
% ./utils/              <--- we need to add these to the active path
%./<currentCase>/<currentSubCase> <--- the directory to be created

casePath = pwd; 
addpath(casePath);

% 2. find 'utils-bSTAB' on the current path and add to active path
if ~isunix
    splts = strfind(casePath, '\');
    if exist([casePath(1:splts(end)), 'utils_bSTAB'])==7
        addpath(genpath([casePath(1:splts(end)), 'utils_bSTAB']));
    else
        warning('could not locate /utils_bSTAB!');
    end
    
else
    splts = strfind(casePath, '/');
    if exist([casePath(1:splts(end)), 'utils_bSTAB'])==7
        addpath(genpath([casePath(1:splts(end)), 'utils_bSTAB']));
    else
        warning('could not locate /utils_bSTAB!');
    end
end

% 3. create subcase folder in current case
if ~isunix
mkdir([casePath, '\', subCasePath]); 
addpath([casePath, '\', subCasePath]); 
else
    mkdir([casePath, '/', subCasePath]); 
addpath([casePath, '/', subCasePath]); 
end

% 4. initialize the props struct that will be the anchor of the calculation
props.casePath = casePath;
props.subCasePath = [casePath, '/', subCasePath];

end

