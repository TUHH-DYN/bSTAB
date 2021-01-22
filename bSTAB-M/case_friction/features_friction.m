function [features] = features_friction(T, Y, props)
% [features] = extract_features_SDOF(T, Y, props)

% computes descriptive features from the time integration data and returns
% the features as a vector that can be used for classification.

% inputs:
% - T: time vector from the time integration
% - Y: states corresponding to T
% - props: property struct with all the required information

% output:
% - features: vector that contains all the features (column!)

% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% -------------------------------------------------------------------------


% 1. detect the steady-state regime (time after props.t_bs)
idx_steady = find(T>props.ti.tStar,1);

if max(abs(Y(idx_steady:end,2))) > 0.2
    features = 1; 
else
    features = 0; 
end
% 
% % 2. extract some features
% %  we simply take the steady state value of the position x (as the mean
% %  variation between minima and maxima)
% [ pos_max, pos_min, ~, ~ ] = computeEnvelopeTimeSeries( Y(:,1) );
% if length(pos_max)>10
%     features = mean(abs(Y(pos_max(end-10:end,1))-Y(pos_min(end-10:end,1))));
% else
%     features = 0;
% end

end

