function plot_exemplary_trajectories(res_detail, props)

% Plotting exemplary trajectories for the solution clusters found in the BS
% study.

res_detail = cell2table(res_detail); % convert to table

uniq_solutions = unique(res_detail.res_detail3); % find set of solutions found
n = length(uniq_solutions); 

% extract initial conditions
ICs = zeros(n,size(res_detail.res_detail1, 2));
for i = 1:n
    idx = find(contains(res_detail.res_detail3,uniq_solutions{i}),1);
    ICs(i,:) = res_detail.res_detail1(idx,:);
    disp(['initial condition for solution ', num2str(i), ': ', num2str(res_detail.res_detail1(idx,:))]);
end

% plotting
figure; 
ode_fun = props.model.odeFun;
tspan = props.ti.tSpan;
options = props.ti.options;
params = num2cell(props.model.odeParams);
p = cell(n,1); 

for i = 1:n
   [T,Y] = ode45(@(t,y) ode_fun(t,y, params{:}), tspan, ICs(i,:), options); 
   p{i} = plot(T, Y(:,1), 'displayName', ['solution ', uniq_solutions{i}]); hold on; 
end
xlabel('time'); ylabel('state 1'); title('exemplary trajectories');legend();

saveas(gcf,[props.subCasePath,'/fig_sampleSolutions'], 'png');
savefig(gcf,[props.subCasePath,'/fig_sampleSolutions']);


end

