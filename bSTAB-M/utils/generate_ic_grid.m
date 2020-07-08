function [IC] = generate_ic_grid(mode, n_points, min_vals, max_vals, props)
% [IC] = generate_ic_grid(mode, n_points, min_vals, max_vals, props)

% generates a grid of initial conditions sampled from the state space
% dimensions specified by the input

% inputs:
% - mode: sampling strategy (uniform, multivariate Gaussian, grid)
% - n_points: vector [n_dof x 1] giving the number of variations per state
% - min_vals: vector [n_dof x 1] giving the minimum values per state
% - max_vals: vector [n_dof x 1] giving the maximum values per state
% - props: property struct for meta parameters

% output:
% - grid: array [n_variations x n_dof] of all initial conditions that arise
%           from the grid generation. n_variations is prescribed by the
%           n_points vector elements.


% (c) Merten Stender
% Hamburg University of Technology, Dynamics Group
% www.tuhh.de/dyn
% m.stender@tuhh.de
% -------------------------------------------------------------------------

% number of DOF read from the min/max value ranges
n_dof = length(min_vals);

% just make sure that we are using integer number of points here
n_points = ceil(n_points); 

% generate set of initial conditions
switch mode
    
    case 'uniform'
        % generates a uniform distribution at random
        [IC] = generate_independent_uniform_distribution(n_points, min_vals, max_vals);
        
    case 'multGauss'
        % generates multivariate independent Gaussian distributions
        [IC] = generate_independent_multivariate_Gaussians(n_points, min_vals, max_vals);
        
    case 'grid'
        % generates a uniformly (linearly) spaced grid
        [IC] = generate_uniformly_spaced_grid(n_points, min_vals, max_vals);
        
    case 'custom'
        % put your custom function here that will return a grid of initial
        % conditions. Format: grid = [n_variations x n_dof]
        
        [IC] = props.bs.sampling_custom_fun(n_points, min_vals, max_vals);
        
    otherwise
        
        error('sorry, the selected sampling strategy is not valid!');
end

% display the sampling of the initial conditions (if plotting is requested)
if props.flag_plotting
    
    figure;
    [S,AX,BigAx,H,HAx] = plotmatrix(IC, '.k');
    for i = 1:n_dof
        for j = 1:n_dof
            if j == 1 && i < n_dof && i ~=1
                AX(i,j).YLabel.String = ['state ', num2str(i)];
                AX(i,j).YLabel.Interpreter = 'latex';
            elseif i == n_dof && j == 1
                AX(i,j).YLabel.String = ['state ', num2str(i)];
                AX(i,j).XLabel.String = ['state ', num2str(j)];
                AX(i,j).XLabel.Interpreter = 'latex';
                AX(i,j).YLabel.Interpreter = 'latex';
            elseif i == n_dof && j > 1
                AX(i,j).XLabel.String = ['state ', num2str(j)];
                AX(i,j).XLabel.Interpreter = 'latex';
            end
        end
    end
    title(BigAx,['initial conditions sampling, $N=', num2str(length(IC)), '$'], 'interpreter', 'latex')
    savefig(gcf, [props.sub_case_path, '/fig_ic_sampling']);
    saveas(gcf, [props.sub_case_path, '/fig_ic_sampling'], 'png');
    close(gcf);
end

end

