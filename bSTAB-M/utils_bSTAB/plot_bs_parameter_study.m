function plot_bs_parameter_study(props, tab, varargin)
% plot_bs_parameter_study(props, tab, plot_error)

% todo: automate class labeling
if length(varargin)>0
    plot_error = varargin{1}; 
else
    plot_error = false; 
end

num_solutions = ((width(tab)-1)/2);

nams = tab.Properties.VariableNames(2:props.templ.k+2); 


figure; 
p = cell(num_solutions, 1);
if plot_error
    for i = 1:num_solutions
        p{i} = errorbar(table2array(tab(:,1)), table2array(tab(:,i+1)), table2array(tab(:, i+1+num_solutions)), 'DisplayName', ['class ', num2str(i)]); hold on; 
    end
else
    for i = 1:num_solutions
        p{i} = plot(table2array(tab(:,1)), table2array(tab(:,i+1)), 'DisplayName', [nams{i}(4:end)], 'marker', '.'); hold on; 
    end
end
legend([p{:}]);
xlabel(['model parameter ', props.ap_study.ap_name], 'interpreter', 'latex'); 
ylabel('$\mathcal{S}_{\mathcal{B}}$', 'interpreter', 'latex'); 
saveas(gcf,[props.subCasePath,'/fig_bs_study'], 'png');
savefig(gcf,[props.subCasePath,'/fig_bs_study']);

end

