function [res] = compute_bs_multi(props, hyp_name, hyp_values)
% [res] = compute_bs_multi(props, hyp_name, hyp_values)


% number of hyperparameter variations
hyper_iters = length(hyp_values);


% now compute the basin stability values

temp_bs_res = cell(hyper_iters, 1);

props.flag_par = true;

for i = 1:hyper_iters
    
    disp(['hyperparameter study ', num2str(i), '/', num2str(hyper_iters)]);
    
    % create a temp variable for the props structure
    temp_props = struct;
    
    % update the hyperparameter in the props struct
    temp_props = update_props(props, hyp_name, hyp_values(i));
    
    % we will disable plotting for now
    temp_props.flag_plotting = false;
    
    % compute the basin stability value for the current parameter setting
    [temp_bs_res{i}, ~] = compute_bs(temp_props);
    
end

% save the results first, then post-process all the numbers
save([props.sub_case_path, '/results_hyperparam_study.mat']);

% let's create a cell array of the length of the number of solutions. Each
% cell will store a table, the label etc. For that purpuse, we need to
% concatenate the sub-tables from the iteration above

res = cell(props.templates.num_solutions+1, 2);

% the first cell column contains the data table, the second column contains
% the labels
hyp_val = nan(hyper_iters, 1);
bs_val = nan(hyper_iters, 1);
num_members = nan(hyper_iters, 1);
err_val = nan(hyper_iters, 1);

for i = 1:props.templates.num_solutions+1 % iterate the different solutions
    
    % assign the label
    if i <= props.templates.num_solutions
        res{i,2} = props.templates.label{i};
    elseif i == props.templates.num_solutions + 1
        res{i,2} = 'NaN';
    end
    
    for j = 1:hyper_iters % iterate the number of parameter variations
        
        % get the table row index for the current label of the solution
        [idx_row] = find(temp_bs_res{j}.bs.label==res{i,2}, 1);
        
        hyp_val(j) = hyp_values(j);
        bs_val(j) = temp_bs_res{j}.bs.basinStability(idx_row);
        num_members(j) = temp_bs_res{j}.bs.absNumMembers(idx_row);
        err_val(j) = temp_bs_res{j}.bs.standardError(idx_row);
    end
    
    % generate a table and save to results cell array
    varNames = {'hyperparameter', 'basinStability', 'numPoints', 'stdError'};
    tab = array2table([hyp_val, bs_val, num_members, err_val], 'variableNames', varNames);
    res{i,1} = tab;
end


end

