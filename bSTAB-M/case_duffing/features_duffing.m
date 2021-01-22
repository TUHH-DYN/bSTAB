function [features] = extract_features_duffing(T, Y, props)
% [features] = extract_features_duffing(T, Y, props)

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

idx_steady = find(T>props.ti.tStar,1);

Y = Y(idx_steady:end,:); 

% we will simply go for the mean and the std of the first state
features(1,1) = max(Y(:,1)); 
features(2,1) = std(Y(:,1));


end

