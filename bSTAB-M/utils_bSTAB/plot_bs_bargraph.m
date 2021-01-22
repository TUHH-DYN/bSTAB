function plot_bs_bargraph(props, res_tab, varargin)
% plot_bs_bargraph(props, res_tab, flag_plotErrorbar)

% Plot the results of the basin stability computation in the form of a bar
% diagram for a single system configuration.

% ### input:
% - props: properties structure
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

if length(varargin)>0
    flag_plotErrorbar = varargin{1};
else
    flag_plotErrorbar = false; % do not plot the error bar
end


figure;
b = bar([1:height(res_tab)],[res_tab.basinStability], ...
    'FaceColor',[.8 .8 .8], ...
    'EdgeColor',[0 0 0], ...
    'LineWidth',1.0); hold on;
xtips1 = b.XData;
ytips1 = b.YData;
labels1 = string(round(b(1).YData,3));
text(xtips1,ytips1,labels1, ...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
if flag_plotErrorbar
    er = errorbar([1:height(res_tab)],[res_tab.basinStability],res_tab.standardError,res_tab.standardError, 'displayName', 'standard error');
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    er.LineWidth = 1;
    legend(er)
end

set(gca, 'Xticklabel', cellstr(res_tab.label));
ylim([-0.1, 1.1]);
ylabel('basin stability'); xlabel('solution label');

saveas(gcf,[props.subCasePath,'/fig_basinstability'], 'png');
savefig(gcf,[props.subCasePath,'/fig_basinstability']);



end