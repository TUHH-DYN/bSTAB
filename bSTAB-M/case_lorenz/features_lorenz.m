function [features] = features_lorenz(T, Y, props)
% [features] = features_lorenz(T, Y, props)

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

% there is the possibility of unbounded solutions - see lorenzStopFcn
if max(abs(Y(:)))>195
    features = 0;
    
else
    % get the steady-state time (no transients here)
    idx_steady = find(T>props.ti.tStar,1);
    Y = Y(idx_steady:end,:);
    
    % we'll simply go for the location of the attractor in x direction (in the
    % negative or the positive regime?)
    
    x_mean = mean(Y(:,1));
    
    if x_mean >0
        features = 1; % solution 1
    else
        features = 2; % solution 2
    end
    
end

end

