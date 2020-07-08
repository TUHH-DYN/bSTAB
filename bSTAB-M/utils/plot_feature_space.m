function plot_feature_space(res_detail)
% plot_feature_space(res_detail)

% plots the feature space and the classification result

% ### input:
% - res_detail: cell array as returned by compute_bs

% ### output:
% - creates a new figure

% ### open points: 
% - let the user choose the dimensions, automatically create subplots

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


X = cell2mat(res_detail(:,2));
L = table2array(cell2table(res_detail(:,3)));

figure; 
gscatter(X(:,1), X(:,2), L);
xlabel('feature $\phi_1$', 'interpreter', 'latex'); 
ylabel('feature $\phi_2$', 'interpreter', 'latex');
title('feature space', 'interpreter', 'latex');

end

