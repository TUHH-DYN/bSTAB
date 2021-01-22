function [ maxIDX, maxVAL ] = findMaxima(Y)
% [ maxIDX, maxVAL ] = findMaxima(Y)
% 
% -------------------------------------------------------------------------
% Merten Stender, 17.05.2017
% Hamburg University of Technology, Dynamics Group
% m.stender@tuhh.de
% -------------------------------------------------------------------------

% Calculate difference
y = diff(Y);

% Detect maxima, account for delay introduced by diff
maxIDX = find(y(1:end-1)>0 & y(2:end)<0)+1;

% Values at maxima
maxVAL = Y(maxIDX);


end

