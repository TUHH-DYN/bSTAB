function [IC] = generate_independent_multivariate_Gaussians(N, min_vals, max_vals)
% [IC] = generate_independent_multivariate_Gaussians(N, min_vals, max_vals)

% Generates multivariate independent Gaussian distributions.
% - N: number samples
% - min_vals: minimum coordinate values. ROW vector
% - max_vals: maximum coordinate values. ROW vector

% - IC: resulting vectors of initial conditions [N x n_dof]

% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% -------------------------------------------------------------------------

disp('initial condition sampling strategy: independent multivariate Gaussians');

ndof = length(min_vals); % degrees of freedom

% we will center the distribution inside the box
mu = mean([min_vals; max_vals], 1);

% covariance matrix that will fit 2 sigma into the box
sigma = sqrt(diag(abs(max_vals-mu)));

% % generate samples (matlab built-in)
% X = mvnrnd(mu,sigma,N);

% manually:
IC = randn(N, ndof); 
IC = IC.*sqrt(diag(sigma))';
IC = IC+ones(N, ndof).*mu;

% figure; 
% plot(IC(:,1), IC(:,2), '.'); hold on; 

% remove all points that are outside the box
for i = 1:ndof
   IC(IC(:,i)<min_vals(i),:) = [];  
   IC(IC(:,i)>max_vals(i),:) = []; 
end

% plot(IC(:,1), IC(:,2), '+');


end

