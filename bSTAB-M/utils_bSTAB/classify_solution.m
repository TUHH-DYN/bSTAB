function [class_result, props] = classify_solution(features, props)
% [class_result] = classify_solution(features, props)

% returns a class label for the given features and the ground truth labels

% inputs:
% - features: column vector containing the features
% - props: property struct with props.ground_truth_templates

% output:
% - class_result: cell
%   + class_result{1}: class label
%   + class_result{2}: classification error (distance metric)


% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
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

