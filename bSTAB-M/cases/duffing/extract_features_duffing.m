function [features] = extract_features_duffing(T, Y, props)
% [features] = extract_features_duffing(T, Y, props)

% computes descriptive features from the time integration data and returns
% the features as a vector that can be used for classification.

% ### input:
% - T: time vector from the time integration
% - Y: states corresponding to T
% - props: property struct with all the required information

% ### output:
% - features: vector that contains all the features (column!)

% ### open points: 
% - 

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

% we will simply go for the mean and the std of the first state
features(1,1) = mean(Y(:,1)); 
features(2,1) = std(Y(:,1));


end

