function [IC] = generate_independent_uniform_distribution(N, min_vals, max_vals, var_dims)
% [IC] = generate_independent_uniform_distribution(N, min_vals, max_vals, var_dims)

% Generates a uniform distribution at random.
% - N: number samples
% - min_vals: minimum coordinate values. ROW vector
% - max_vals: maximum coordinate values. ROW vector
% - var_dims: boolean vector indicating which DOF to vary

% - IC: resulting vectors of initial conditions [N x n_dof]

% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% -------------------------------------------------------------------------

disp('initial condition sampling strategy: uniform random');

if size(min_vals,1)>size(min_vals,2)
    min_vals = min_vals'; 
end

if size(max_vals,1)>size(max_vals,2)
    max_vals = max_vals'; 
end

ndof = length(min_vals); % degrees of freedom

% initialize
IC = ones(N, ndof); 

for i=1:ndof
    if var_dims(i)
       IC(:,i) =  scale2range(rand(N,1), min_vals(i), max_vals(i));
    else
        IC(:,i) = min_vals(i).*IC(:,i); 
    end
end
% % 
% % % we will center the distribution inside the box
% % mu = mean([min_vals; max_vals], 1);
% % 
% % % covariance matrix that will fit 2 sigma into the box
% % sigma = diag(abs(max_vals-mu));
% % 
% % % manually:
% % IC = (rand(N, ndof)-0.5).*2; 
% % IC = IC.*diag(sigma)';
% % IC = IC+ones(N, ndof).*mu;
% % 
% % % figure; 
% % % plot(X(:,1), X(:,2), '.'); hold on; 
% % 
% % % remove all points that are outside the box
% % for i = 1:ndof
% %    IC(IC(:,i)<min_vals(i),:) = [];  
% %    IC(IC(:,i)>max_vals(i),:) = []; 
% % end

% plot(X(:,1), X(:,2), '+');


end

