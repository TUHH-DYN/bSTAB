function [ pos_max, pos_min, val_max, val_min ] = computeEnvelopeTimeSeries( Y )
%[ pos_max, pos_min, val_max, val_min ] = computeEnvelopeTimeSeries( Y )
%   Computes the envelope of a time series given in Y.

% -------------------------------------------------------------------------
% Merten Stender, 24.10.2016
% Hamburg University of Technology, Dynamics Group
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


% Calculate difference
y = diff(Y);

% Detect minima and maxima, account for delay introduced by diff
pos_max = find(y(1:end-1)>0 & y(2:end)<0)+1;
pos_min = find(y(1:end-1)<0 & y(2:end)>0)+1;



% Values at maxima / minima
val_max = Y(pos_max);
val_min = Y(pos_min);


end


