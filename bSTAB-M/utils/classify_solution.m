function [class_result] = classify_solution_v2(features, props)
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

% number of initial conditions features = [n x dof]
n = size(features, 1);

class_label = cell(n,1);
class_error = nan(n,1);

% --- A simple Euclidean distance measure ---

% iterate over each feature vector and classify
for i = 1:n

    diffs = nan(props.templates.num_solutions,1);
    
    % iterate over the template candidates
    for j = 1:props.templates.num_solutions
        
        % compare the current feature vector to the template
        diffs(j) = euclid_dist(features(i,:)', props.templates.features{j});
        
    end
    
    % now find the minimal distance (primitive classifier)
    [class_error(i), min_idx] = min(diffs);
    
    % check if the classification tolerance is violated. Return NaN in this
    % case
    if class_error(i) < props.bs.class_tol
        
        % return the label of the matching steady-state solution
        class_label{i} = props.templates.label{min_idx};
    else
        % distance metric too large: return NaN. Maybe increase the integration
        % time to reduce the NaN cases. Or increase the classification
        % tolerance value. Or choose a different distance metric
        class_label{i} = 'NaN';
    end
    
    
end

% turn everything into a table
class_result = array2table(categorical(cellstr(class_label)), 'VariableNames', {'label'});
class_result = [class_result, array2table(class_error, 'VariableNames', {'error'})];

end

% --- some distance functions
function dist_ = euclid_dist(x, y)

dist_ = sqrt(sum((x-y).^2));

end

