function [IC] = generate_uniformly_spaced_grid(N, min_vals, max_vals)
% [IC] = generate_uniformly_spaced_grid(N, min_vals, max_vals)

% Generates a uniform distribution at random.
% - N: number samples
% - min_vals: minimum coordinate values. ROW vector
% - max_vals: maximum coordinate values. ROW vector

% - X: resulting vectors of initial conditions [N x n_dof]

% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% -------------------------------------------------------------------------

disp('initial condition sampling strategy: uniformly spaced grid');

% number of states
n_dof = length(min_vals);

% N denotes the overall number of points, so if we have n_dof dimensions,
% we need to take the n_dof'th root to find the number of grid points per
% dimension
N_per_dim = ceil(N^(1/n_dof)); % we will round up


%         --- THE MANUAL WAY TO UNDERSTAND THE CODING ---
%         % example: we want to create a grid in 2 dimensions between [-2, 2]
%         % and [-3, 3] with spacing = 1. So we need to arrive at 5*7 = 35
%         % grid points, each of which featuring a 2-dimensional vector [x,y]
%         x_span = linspace(min_vals(1), max_vals(1), n_points(1)); n_x = length(x_span);
%         y_span = linspace(min_vals(2), max_vals(2), n_points(2)); n_y = length(y_span);
%
%         % create the grid
%         [X,Y] = ndgrid(x_span, y_span);
%
%         % reshape into a one-dimensional vector
%         x_vec = reshape(X, n_x*n_y, 1);
%         y_vec = reshape(Y, n_x*n_y, 1);
%
%         % built a 2D vector of all possible combinations and return the
%         % grid as an array [n_variations x n_dof]
%         grid = [x_vec, y_vec];

%         --- THE AUTOMATED CODE ---

% store all the variations of each state in a cell array (as they have
% different lengths, we cannot use an array)
state_variations = cell(n_dof, 1);

% % compute the rsulting number of variations in the n_dof space
% n_variations = 1;
% for i=1:n_dof
%     n_variations = n_variations*n_points(i);
% end

% now create the variations in each state dimension
for i = 1:n_dof
    state_variations{i} = linspace(min_vals(i), max_vals(i), N_per_dim);
end

% generate the grid of all possible combinations
% as the ndgrid function returns a variable number of outputs, we
% will have to use the eval function here to capture the variable
% numbers of outputs.
IC_temp = cell(n_dof, 1);

% generate the output string '[IC_temp{1}, IC_temp{2}, ... ]'
out_str = '[';
for i = 1:n_dof
    out_str = [out_str, 'IC_temp{', num2str(i), '}, '];
end
% remove last comma and add square bracket
out_str = [out_str(1:end-2), ']'];

% now call the ndgrid with the variable number of inputs and
% outputs: [X{1}, X{2}] = ndgrid(x1, x2);
eval([out_str, ' = ndgrid(state_variations{:});'])

% reshape into one-dimensional vectors
IC_reshaped = cell(n_dof, 1);
for i = 1:n_dof
    IC_reshaped{i} =  reshape(IC_temp{i}, N_per_dim^n_dof, 1);
end

% now build the grid by assembling the vectors per state into an
% array [n_variations x n_dof] grid = [x_vec, y_vec];
IC = [IC_reshaped{:}];

end
