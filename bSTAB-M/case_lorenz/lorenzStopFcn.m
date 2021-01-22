function [value, isterminal, direction] = lorenzStopFcn(t,y)
% [value, isterminal, direction] = lorenzStopFcn(t,y)

maxval = 200; % stop the time integration after reaching this amplitude

direction  = 0;
value = (abs(max(y))-maxval);
isterminal = 1; % halts the time integration

end
