function save_for_python(props, res_detail)
% save_for_python(props, res_detail)

% Export the relevant info to a csv file that can be used for
% post-processing
% -------------------------------------------------------------------------

% we are interested in
% -> the features extracted from the steady-state time series
% (located in 2nd column of 'res_detail')
% -> the related initial conditions

% first check if we have a single parameter configuration or if we ran a
% parametric study

if isfield(props, 'ap_study')

    for iter=1:length(res_detail)

        curr_tab = res_detail{iter};

        % now extract all relevant quantities and column names
        % Extract initial conditions
        init_conds = cell2mat(curr_tab(:,1));
        num_states = size(init_conds, 2);

        % Extract features
        features = cell2mat(curr_tab(:,2));
        num_feat = size(features,2);

        exp_data = [init_conds, features];

        col_names = cell(1, num_states + num_feat);
        for i = 1:num_states
            col_names{i} = ['ic_state_' num2str(i)];
        end
        for i = 1:num_feat
            col_names{num_states+i} = ['feat_' num2str(i)];
        end


        % Create a table with column names
        table_data = array2table(exp_data, 'VariableNames', col_names);

        % Define the filename
        % update current variable parameter
        props.model.odeParams(props.ap_study.ap) = props.ap_study.ap_values(iter);

        str_details = strrep(props.ap_study.ap_name, '$', '');  % remove $ chars
        str_details = [str_details, '_', num2str(props.ap_study.ap_values(iter))];

        filename = [props.subCasePath, '/results_basinstability_', str_details, '.csv'];

        % Export the table to a CSV file
        writetable(table_data, filename);
    end

else

    curr_tab = res_detail;

    % now extract all relevant quantities and column names
    % Extract initial conditions
    init_conds = cell2mat(curr_tab(:,1));
    num_states = size(init_conds, 2);

    % Extract features
    features = cell2mat(curr_tab(:,2));
    num_feat = size(features,2);

    exp_data = [init_conds, features];

    col_names = cell(1, num_states + num_feat);
    for i = 1:num_states
        col_names{i} = ['ic_state_' num2str(i)];
    end
    for i = 1:num_feat
        col_names{num_states+i} = ['feat_' num2str(i)];
    end

    % Create a table with column names
    table_data = array2table(exp_data, 'VariableNames', col_names);

    % % Define the filename
    % str_details = sprintf('%03f_', props.model.odeParams);
    % str_details = str_details(1:end-1); % Remove the trailing underscore
    % 
    % filename = [props.subCasePath, '/results_basinstability_', str_details, '.csv'];
    filename = [props.subCasePath, '/results_basinstability.csv'];

    % Export the table to a CSV file
    writetable(table_data, filename);

end



end



