function plot_parameter_study(tab, props, plot_error)

% todo: automate class labeling

num_solutions = ((width(tab)-1)/2);

figure; 
p = cell(num_solutions, 1);
if plot_error
    for i = 1:num_solutions
        p{i} = errorbar(table2array(tab(:,1)), table2array(tab(:,i+1)), table2array(tab(:, i+1+num_solutions)), 'DisplayName', ['class ', num2str(i)]); hold on; 
    end
else
    for i = 1:num_solutions
        p{i} = plot(table2array(tab(:,1)), table2array(tab(:,i+1)), 'DisplayName', ['class ', num2str(i)], 'marker', '.'); hold on; 
    end
end
legend([p{:}]);
xlabel(['model parameter ', props.ap_study.ap_name], 'interpreter', 'latex'); 
ylabel('$\mathcal{S}_{\mathcal{B}}$', 'interpreter', 'latex'); 

end

