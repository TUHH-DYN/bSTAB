function [x_rescaled] = scale2range(x, a, b)
% [x_rescaled] = scale2range(x, a, b)
% Scales signal x to the range [a, b]

% -------------------------------------------------------------------------
% Merten Stender, 06.02.2018
% Hamburg University of Technology, Dynamics Group
% m.stender@tuhh.de
% -------------------------------------------------------------------------

if length(unique(x))==1
    x_rescaled = mean([a, b]);
else
    x_rescaled = (x-min(x))*(b-a)/(max(x)-min(x))+a;
end

end

