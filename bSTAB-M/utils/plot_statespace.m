function plot_statespace(res_detail, state1, state2)
% plot_statespace(res_detail)

% plots the state space as sampled with class labels

% ### input:
% - res_detail: cell array as returned by compute_bs
% - state1: first state to plot (index)
% - state2: second state to plot (index)

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

Y0 = cell2mat(res_detail(:,1));
L = table2array(cell2table(res_detail(:,3)));

figure;
gscatter(Y0(:,state1), Y0(:,state2), L);
xlabel(['$y_', num2str(state1), '$'], 'interpreter', 'latex');
ylabel(['$y_', num2str(state2), '$'], 'interpreter', 'latex');

% % % more advanced solution
% figure; 
% Y0 = cell2mat(res_detail(:,1));
% X = cell2mat(res_detail(:,2));
% L = table2array(cell2table(res_detail(:,3)));
% index = cellfun(@(x) strcmp(x, 'FP'), L, 'UniformOutput', true);
% plot(Y0(index,1), Y0(index, 2), 'k.');

end

