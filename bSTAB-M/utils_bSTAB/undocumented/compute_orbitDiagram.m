function [MAXI] = compute_orbitDiagram(odefun, tspan, y0, p0, pidx, pGrid, varargin)

%  [maxima] = compute_orbitDiagram(odefun, tspan, y0, p0, pidx, pGrid, tdisc, numDOF)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% default: discard first half of time integration
tdisc = tspan(end)/2;

% default: compute orbit diagram for each DOF
maxDOF = length(y0);
DOF = [1:maxDOF];

if nargin == 7
    tdisc = varargin{1};
elseif nargin == 8
    tdisc = varargin{1};
    DOF = varargin{2};
end

numDOF = numel(DOF);

if max(DOF)>maxDOF
    error('Wrong state index');
end

if tdisc >=tspan(end)
    error('Choose a smaller tdisc');
end


% number of time series to compute
N = length(pGrid);
maxima = cell(numDOF, N);
maxLen = ones(numDOF,1);

% loop over parameter grid: compute time integration, find maxima
parfor i = 1:N
    
    disp([num2str(i), '/', num2str(N)]);
    
    % parameter updating
    p = p0; p(pidx) = pGrid(i); P = num2cell(p);
    
    % time integration
    options = odeset('RelTol',1e-9,'AbsTol',1e-10);
    [t,y] = ode113(@(t,y) odefun(t,y, P{:}), tspan, y0, options);
    
    
    % discard transients
    idx = find(t>tdisc, 1, 'first');
    t = t(idx:end); y = y(idx:end, :);
    
    for j = 1:numDOF
        
        % find maxima
        [ ~, ~, maxima{j,i}, ~] = computeEnvelopeTimeSeries(y(:,DOF(j)));
        
    end
end

% number of entries
for i = 1:N
    for j = 1:numDOF
        maxLen(j) = max([maxLen(j), length(maxima{j,i})]);
    end
end

% Combine entries to matrix
MAXI = cell(numDOF,1);
for j=1:numDOF
    
    MAXI{j} = nan(maxLen(j), N);
    for i = 1:N
        MAXI{j}(1:length(maxima{j,i}),i) = maxima{j,i};
    end
    
end



figure;
for j = 1:numDOF
    ax{j} = subplot(numDOF, 1, j);
    plot(pGrid, MAXI{j}, 'k.');
    title(['DOF #', num2str(DOF(j))], 'FontWeight', 'Normal', 'interpreter', 'latex')
    if j==numDOF
        xlabel('Parameter', 'Interpreter', 'latex'); linkaxes([ax{:}], 'x');
    end
end




end

function [ pos_max, pos_min, val_max, val_min ] = computeEnvelopeTimeSeries( Y )
%[ pos_max, pos_min, val_max, val_min ] = computeEnvelopeTimeSeries( Y )
%   Computes the envelope of a time series given in Y.

% -------------------------------------------------------------------------
% Merten Stender, 24.10.2016
% Hamburg University of Technology, Dynamics Group
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


% figure;
% plot(Y); hold on; 

% Calculate difference
y = diff(Y);

% Detect minima and maxima, account for delay introduced by diff
pos_max = find(y(1:end-1)>0 & y(2:end)<0)+1;
pos_min = find(y(1:end-1)<0 & y(2:end)>0)+1;

% plot(pos_max,Y(pos_max), 'r*'); 
% plot(pos_min,Y(pos_min),'bo');  

% Values at maxima / minima
val_max = Y(pos_max);
val_min = Y(pos_min);


end



