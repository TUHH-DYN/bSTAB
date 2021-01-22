function plot_bs_featurespace(props, res_detail)
% plot_bs_featurespace(props, res_detail)

% plots the feature space and the classification result

% ### input:
% - props: properties struct
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
if props.clust.numFeatures == 1
    for i = 1:props.templ.k
        p = plot(props.templ.features{i}(1), 'x', 'markersize', 6, 'linewidth', 2, 'displayName', 'class templates'); hold on; 
    end
%     to do!
% % %     for i = 1:props.templ.k
% % %         plot()
% % %     end
elseif props.clust.numFeatures == 2
figure; 
for i = 1:props.templ.k
   p = plot(props.templ.features{i}(1),  props.templ.features{i}(2), 'x', 'markersize', 6, 'linewidth', 2, 'displayName', 'class templates'); hold on; 
end
gs = gscatter(X(:,1), X(:,2), L);
legend([p, gs'])
xlabel('feature $X_1$', 'interpreter', 'latex'); 
ylabel('feature $X_2$', 'interpreter', 'latex');
end
title('feature space', 'interpreter', 'latex');

saveas(gcf,[props.subCasePath,'/fig_featurespace'], 'png');
savefig(gcf,[props.subCasePath,'/fig_featurespace']);

end

