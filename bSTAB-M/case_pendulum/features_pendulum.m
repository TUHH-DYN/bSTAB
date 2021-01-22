function [X] = features_pendulum(T, Y, props)
% [X] = features_pendulum(T, Y, props)

% computes descriptive features from the time integration data and returns
% the features as a vector that can be used for classification.

% inputs:
% - T: time vector from the time integration
% - Y: states corresponding to T
% - props: property struct with all the required information

% output:
% - X: vector that contains all the features (column!)

% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% -------------------------------------------------------------------------


% 1. detect the steady-state regime (time after props.ti.tStar)
idx_steady = find(T>props.ti.tStar,1);

% 2. extract some features (must work for all values of T, hence a bit
% tricky
Delta = abs(max(Y(idx_steady:end,2)) - mean(Y(idx_steady:end,2)));

% one-hot encoded labels
if Delta<0.01
    X(1,1) = 1; %FP
    X(2,1) = 0;
else
    X(1,1) = 0; %LC
    X(2,1) = 1;
end
%
% figure;
% plot(Y(idx_steady:end, 2)); hold on;


end
