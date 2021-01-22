function [IC] = generate_ic_grid(props)
% [IC] = generate_ic_grid(props)

% generates a grid of initial conditions sampled from the state space
% dimensions specified by the input

% inputs:
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

mode = props.roi.samplingPDF; %sampling strategy ('uniform', 'multGauss', 'grid', 'custom')
n_points = props.roi.N; %[n_dof x 1] giving the number of variations per state
min_vals = props.roi.minLimits; %[n_dof x 1] giving the minimum values per state
max_vals = props.roi.maxLimits; %vector [n_dof x 1] giving the maximum values per state
var_dims = props.bs.samplingVarDims; % bool: indicate which DOF to vary

% number of DOF read from the min/max value ranges
n_dof = props.model.dof;

% just make sure that we are using integer number of points here
n_points = ceil(n_points); 

% generate set of initial conditions
switch mode
    
    case 'uniform'
        % generates a uniform distribution at random
        [IC] = generate_independent_uniform_distribution(n_points, min_vals, max_vals, var_dims);
        
    case 'multGauss'
        % generates multivariate independent Gaussian distributions
        [IC] = generate_independent_multivariate_Gaussians(n_points, min_vals, max_vals, var_dims);
        
    case 'grid'
        % generates a uniformly (linearly) spaced grid
        [IC] = generate_uniformly_spaced_grid(n_points, min_vals, max_vals, var_dims);
        
    case 'custom'
        % put your custom function here that will return a grid of initial
        % conditions. Format: grid = [n_variations x n_dof]
        [IC] = props.bs.samplingCustomFun(n_points, min_vals, max_vals, var_dims);
        
    otherwise
        
        error('sorry, the selected sampling strategy is not valid!');
end

% display the sampling of the initial conditions (if plotting is requested)
if props.flagShowFigures
    
    figure;
    [~,AX,BigAx,~,~] = plotmatrix(IC, '.k');
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
    savefig(gcf, [props.subCasePath, '/fig_ic_sampling']);
    saveas(gcf, [props.subCasePath, '/fig_ic_sampling'], 'png');
    close(gcf);
end

end

