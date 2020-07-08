function [features] = extract_features_pendulum(T, Y, props)
% [features] = extract_features_pendulum(T, Y, props)

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
idx_steady = find(T>props.ti.t_star,1);

% 2. extract some features
% 
% % here we will only take the (abs) maximum of the second state (\omega) and
% % its standard deviation. 

features(1,1) = max(abs(Y(idx_steady:end,2))); 
features(2,1) = std(abs(Y(idx_steady:end,2))); 
% 
% alpha = props.model.ode_params(1);
% T = props.model.ode_params(2);
% K = props.model.ode_params(3);
% 
% devi = max(abs(Y(idx_steady:end,2)-T/alpha));
% 
% if devi <0.5 
%     features(1,1) = 1; 
%     features(2,1) = 0; 
% else
%     features(1,1) = 0; 
%     features(2,1) = 1; 
% end

end

