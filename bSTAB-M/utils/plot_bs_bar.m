function plot_bs_bar(tab, plot_errorbar)
% plot_bs_bar(tab, plot_errorbar)

% Plot the results of the basin stability computation in the form of a bar
% diagram for a single system configuration.

% ### input:
% - tab: res_tab variable returned by compute_bs
% - plot_errorbar: boolean indicating whether to plot the std. errors

% ### output:
% - creates a new figure

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


figure;
b = bar([1:height(tab)],[tab.basinStability], ...
    'FaceColor',[.8 .8 .8], ...
    'EdgeColor',[0 0 0], ...
    'LineWidth',1.0); hold on;
xtips1 = b.XData;
ytips1 = b.YData;
labels1 = string(round(b(1).YData,2));
text(xtips1,ytips1,labels1, ...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
if plot_errorbar
    er = errorbar([1:3],[tab.basinStability],tab.standardError,tab.standardError);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    er.LineWidth = 1;
end
set(gca, 'Xticklabel', cellstr(tab.label));
ylim([-0.1, 1.1]);
ylabel('basin stability'); xlabel('solution label');


end

