function [class_result, props] = classify_solution(features, ic_grid, props)
% [class_result] = classify_solution(features, props)

% returns a class label for the given features and the ground truth labels

% inputs:
% - features: column vector containing the features
% - props: property struct with props.ground_truth_templates

% output:
% - class_result: cell
%   + class_result{1}: class label
%   + class_result{2}: classification error (distance metric)


% 18.03.2021
% -------------------------------------------------------------------------
% Copyright (C) 2020 Merten Stender (m.stender@tuhh.de)
% Hamburg University of Technology, Dynamics Group, www.tuhh.de/dyn

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

if strcmp(props.clust.clustMode, 'supervised')
    % supervised setting: we have a clear picture about all possible solutions
    % of the system in the region of interest. The user specified initial
    % conditions and model parameters for each class of solutions, such that we
    % can generate template feature vectors.
    [props] = generate_feature_templates(props);
    
    % number of classes
    k = props.templ.k;
    
    % iterate over the template candidates and create matrix
    featureVectors = nan(props.templ.k, props.clust.numFeatures);
    for j = 1:k
        featureVectors(j, :) = props.templ.features{j}';
    end
    
    % now find the classification by the nearest neighbors
    switch props.clust.clustMethod
        
        case 'kNN' % k=1 nearest neighbor classification
            % find nearest neighbor through kNN (k=1). Requires Statistics and
            % Machine Learning Toolbox
            dist_norm = props.clust.clustMethodNorm; %possible choices: 'seuclidean', 'cityblock', 'chebychev', 'minkowski', 'mahalanobis', 'cosine', 'correlation', 'spearman', 'hamming', 'jaccard'
            [class_label, class_error] = knnsearch(featureVectors,features, 'K', 1, 'Distance', dist_norm);
            
        case 'kNN_thresholded' % kNN with threshold for maximum distance
            % creates NaN class if distance is larger than threshold
            thres = props.clust.clustMethodTol;
            dist_norm = props.clust.clustMethodNorm; %possible choices: 'seuclidean', 'cityblock', 'chebychev', 'minkowski', 'mahalanobis', 'cosine', 'correlation', 'spearman', 'hamming', 'jaccard'
            [class_label, class_error] = knnsearch(featureVectors,features, 'K', 1, 'Distance', dist_norm);
            
            % idx_invalid = false(size(class_label));
            class_label(class_error>thres)=NaN;
            
        otherwise
            warning('clustering mode not available');
    end
    
    
elseif strcmp(props.clust.clustMode, 'unsupervised')
    
    % still to do
    % props.templ.label = ..??
    disp('using DBSCAN to find clusters')
    
    % check if you have access to functions dbscan and silhouette
    if license('test', 'Statistics_Toolbox')
        
        % % ---------------------------------------------------------------
        % % finding the optimal epsilon can be challenging. here are some
        % % trials that were discarded.
        %     % minimum number of points to form a cluster
        %     minpts = 10;
        %     % pre-compute the pairwise distances
        %  see https://iopscience.iop.org/article/10.1088/1755-1315/31/1/012012/pdf
        %     D = pdist2(features,features);
        %     kD = pdist2(features,features,'euc','Smallest',10); % The minpts smallest pairwise distances
        % %     kD = pdist2(features,features,'euc');
        % %     m  = triu(true(size(kD)));
        % %     kD = sort(kD(m));
        %     kD = sort(kD(end,:));
        %     kD_s = smooth(kD, round(length(features)/100, 0));
        %     kD_s = kD;
        %     % compute derivatives
        %     kD_d = gradient(kD_s);
        %     kD_dd = gradient(smooth(kD_d, 1*minpts));
        %     % find most prominent peak in 2nd derivative
        %     [~, pk_idx, ~, p] = findpeaks(kD_dd, 'SortStr','descend');
        %     [~, max_p] = max(p);
        %     max_idx = pk_idx(max_p);
        %     % set reasonable epsilon range
        %     eps_low = kD(max_idx-5*minpts);
        %     eps_up = kD(max_idx+1*minpts);
        % %     Plot the k-distance graph.
        %     figure;
        %     plot(kD./max(kD)); hold on;
        %     plot(kD_d./max(abs(kD_d)));
        %     plot(kD_dd./max(abs(kD_dd)));
        %     plot(max_idx,kD_dd(max_idx)./max(abs(kD_dd)), 'r*');
        %     plot([0, length(kD)], ones(1,2).*eps_low./max(abs(kD)), 'k--');
        %     plot([0, length(kD)], ones(1,2).*eps_up./max(abs(kD)), 'k--');
        %     title('k-distance graph')
        %     xlabel(['Points sorted with ',num2str(minpts) ,' nearest distances'])
        %     ylabel([num2str(minpts), 'th nearest distances']);
        %     legend('distances', '1st derivative', '2nd derivative', 'search bound for epsilon');
        %     grid
        %
        %     eps_optimal = kD(max_idx)*10;
        %     class_idx = dbscan(D,eps_optimal,minpts,'Distance','precomputed');
        %      figure;
        %      plot(features(:,1), features(:,2), 'k*'); hold on;
        %         gscatter(features(:,1), features(:,2), class_idx)
        %         xlabel('feature 1'); ylabel('feature 2');
        %         title('DBSCAN unsupervised clustering');
        
        % select the bounds of epsilon variations as the maximum distances and
        % the 10th of the mean
        %     eps_grid = logspace(log10(eps_low), log10(eps_up), 200);
        %     eps_grid = linspace(eps_low, eps_up, 200);
        %     eps_grid = kD(max_idx-5*minpts: max_idx+1*minpts);
        % %  --------------------------------------------------------------
        
        % pre-compute the pairwise distances
        D = pdist2(features,features);
        
        % minimum number of points to form a cluster
        minpts = 10;
        
        % specify the range of the epsilon
        feat_ranges = max(features,[], 1)-min(features,[], 1);
        eps_grid = linspace(min(feat_ranges)/200, min(feat_ranges), 200);
        
        k_grid = nan(size(eps_grid));  % number of clusters
        s_grid = nan(size(eps_grid));  % min silhouette values (which we want to maximize)
        
        % variation of epsilon to find the best one
        for i = 1:length(eps_grid)
            class_label = dbscan(D,eps_grid(i),minpts,'Distance','precomputed');
            class_label(class_label==-1) = NaN;
            k_grid(i) = numel(unique(class_label(~isnan(class_label))));
            s = silhouette(features,class_label);
            s_grid(i) = min(s);
            clear class_idx s
        end
        
        % find the optimal epsilon through the maximum silhouette value
        if any(~isnan(s_grid))
            
            [~, idx_optimal] = findpeaks(s_grid);
            if ~isempty(idx_optimal)
                eps_optimal = eps_grid(idx_optimal);
            else
                [~, idx_optimal] = max(s_grid);
                eps_optimal = eps_grid(idx_optimal);
            end
            
            % now compute the final clustering
            class_label = dbscan(D,eps_optimal,minpts,'Distance','precomputed');
            
            if props.flagShowFigures
                figure;
                ax1 = subplot(1,2,1);
                plot(eps_grid, k_grid, '-', 'marker', '.'); hold on;
                plot(eps_grid(idx_optimal), k_grid(idx_optimal), 'r*');
                title('search optimal epsilon for DBSCAN');
                xlabel('epsilon'); ylabel('number of clusters found');
                ax2 = subplot(1,2,2);
                plot(eps_grid, s_grid, '-', 'marker', '.'); hold on;
                plot(eps_grid(idx_optimal), s_grid(idx_optimal), 'r*');
                xlabel('epsilon'); ylabel('min. cluster silhouette value');
                legend('to be maximized', 'selected finally');
                title(['epsilon = ', num2str(eps_optimal)])
                linkaxes([ax1, ax2], 'x');
                savefig(gcf, [props.subCasePath, '/fig_DBSCAN_epsilon']);
                saveas(gcf, [props.subCasePath, '/fig_DBSCAN_epsilon'], 'png');
                close(gcf);
            end
            
        else % no distinct cluster found - we set all to one single cluster
            class_label = ones(size(features,1),1);
        end
        
        % (-1) indicates outlier / no-cluster point
        class_label(class_label==-1) = NaN;
        
        % get the number of clusters k (disregarding the outliers)
        k = numel(unique(class_label(~isnan(class_label))));
        disp(['unsupervised clustering found ', num2str(k), ' clusters'])
        
        % update the props.templ. struct
        props.templ = [];
        props.templ.k = k;
        props.templ.Y0 = cell(1,k);
        props.templ.modelParams = cell(1,k);
        props.templ.label = cell(1,k);
        props.templ.features = cell(1,k);
        
        % we do not have any templates available, so we need to create labels
        % on our own.
        K = nan(k,1);
        class_error = nan(size(class_label));
        
        for i = 1:k
            K(i) = sum(class_label==i);
            disp(['Number of memebers for cluster ', num2str(i), ': ', num2str(K(i))])
            
            % compute some 'error' metric. First find the center per cluster
            meanpt = mean(features(class_label==i,:), 1);
            props.templ.features{i} = meanpt;
            
            % compute euclidean distance
            dists = sqrt(sum((features-meanpt) .^ 2, 2));
            class_error(class_label==i) = dists(class_label==i);
            
            % update the props.templ entries
            ic_templ = ic_grid(class_label==i,:);
            props.templ.Y0{i} = ic_templ(1,:);
            props.templ.modelParams{i} = props.model.odeParams;
            props.templ.label{i} = ['y', num2str(i)];
        end
        
        %         % some plotting
        %         if size(features,2)>=2
        %             figure;
        %             plot(features(:,1), features(:,2), 'k*'); hold on;
        %             gscatter(features(:,1), features(:,2), class_label)
        %             xlabel('feature 1'); ylabel('feature 2');
        %             title('DBSCAN unsupervised clustering');
        %         end
        
    else
        warning('ML and Statistics Toolbox is required for dbscan');
    end
    
else
    warning('clustering mode unknown!');
end


% turn everything into a table.
% - NaNs indicate invalid class memberships (i.e. distance to feature
% templates is too large)
class_result = array2table([class_label, class_error], 'VariableNames', {'label', 'error'});


end

% % --- A simple Euclidean distance measure ---
%
% % iterate over each feature vector and classify
% for i = 1:n
%
%     diffs = nan(k,1);
%
%     % iterate over the template candidates and create matrix
%     featureVectors = nan(props.templ.k, props.clust.numFeatures);
%     for j = 1:k
%
%         % compare the current feature vector to the template
%         diffs(j) = euclid_dist(features(i,:)', props.templ.features{j});
%
%     end
%
%     % now find the minimal distance (primitive classifier)
%     [class_error(i), min_idx] = min(diffs);
%
%     % check if the classification tolerance is violated. Return NaN in this
%     % case
%     if class_error(i) < props.clust.tol
%
%         % return the label of the matching steady-state solution
%         class_label{i} = props.templ.label{min_idx};
%     else
%         % distance metric too large: return NaN. Maybe increase the integration
%         % time to reduce the NaN cases. Or increase the classification
%         % tolerance value. Or choose a different distance metric
%         class_label{i} = 'NaN';
%     end
%
%
% end
%
% class_result = array2table(categorical(cellstr(class_label)), 'VariableNames', {'label'});
% class_result = [class_result, array2table(class_error, 'VariableNames', {'error'})];



% end

% % --- some distance functions
% function dist_ = euclid_dist(x, y)
%
% dist_ = sqrt(sum((x-y).^2));
%
% end

