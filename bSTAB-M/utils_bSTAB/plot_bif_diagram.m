function plot_bif_diagram(props, res_detail, dof)

% number of coordinates to plot
n_dofs = length(dof);
n_clusts = props.templ.k;

% bifurcation diagram will be computed only for parameter variation study
if isfield(props, 'ap_study')
    if strcmp(props.ap_study.mode, 'model_parameter')
        flag_par_var = true;
        num_par_var = size(res_detail, 1);
    end
else
    flag_par_var = false; % only one point computed, so only one point will result
end

if flag_par_var
    
    % we'll store the amplitudes here
    amplitudes = nan(n_clusts, n_dofs, num_par_var);
    errs = nan(n_clusts, n_dofs, num_par_var);
    
    % iterate over model parameter varations
    for idx_p = 1:num_par_var
        
        % do a k-means clustering of the amplitudes obtained at the current
        % parameter value
        [amplitudes(:, :, idx_p), errs(:, :, idx_p)] = get_amplitudes(res_detail{idx_p}, dof, n_clusts);
        
        
    end
else
    
    [amplitudes(:, :, 1), errs(:, :, 1)] = get_amplitudes(res_detail, dof, n_clusts);
end

% 4. finally: plotting
figure;
for idx_d = 1:n_dofs
    ax{idx_d} = subplot(1,n_dofs, idx_d);
    
    for idx_c = 1:n_clusts
        if flag_par_var
            plot(props.ap_study.ap_values, reshape(amplitudes(idx_c,idx_d, :), num_par_var, 1), 'k.'); hold on;
        else
            plot(1, reshape(amplitudes(idx_c,idx_d, :), 1, 1), 'k.'); hold on;
        end
    end
    ylabel(['amplitude state ', num2str(dof(idx_d))]);
end

linkaxes([ax{:}], 'xy');


end


function [amps, diffs] = get_amplitudes(data_cell, dof, n_clust)
% [amps, diffs] = get_amplitudes(data_cell)

n_dofs = length(dof);

% select only the requested dofs
temp = cell2mat(data_cell(:,5));
temp = temp(:,dof);

%  2. k-means clustering
% [cluster indices, cluster centroids]
[idx,amps] = kmeans(temp, n_clust);

% 3. compute some error values for each cluster
diffs = nan(size(amps));

for idx_d = 1:n_dofs
    for idx_c = 1:n_clust
        diffs(idx_c,idx_d) = mean(abs(temp(idx==idx_c,idx_d)-amps(idx_c,idx_d)));
    end
end




end

