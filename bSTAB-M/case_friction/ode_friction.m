function [dydt] = ode_friction(t,y,v_d)
% t: time
% x: state vector [disp, vel]
% xi: damping ratio
% vdr: driving velocity
% musd: ratio static to dynamic friction coefficient

vrel = y(2) - v_d;          % relative velocity
eta = 1e-4;                % stick is detected if abs(vrel) < eta

% paramters
v0 = 0.5;             % reference velocity if exponential decay is used
musd = 2;             % ratio static to dynamic fric coeff, mu_st/mu_d
mud = 0.5;            % dynamic coeff of friction, mu_d
xi = 0.05;            % Damping ratio of the SDOF system
muv = 0;              % linear strengthening parameter


% friction force
Ffric = friction_law(vrel,mud,musd,muv,v0);      % Insert here the proper friction law


if  abs(vrel) > eta
    
    % Slip Equation
    dydt = [y(2);
        -y(1) - 2*xi*y(2) - sign(vrel)*Ffric ]; %
    
elseif abs(y(1) + 2*xi*y(2)) > mud*musd
    
    % Transition Stick to Slip
    dydt = [y(2);
        -y(1) - 2*xi*y(2) + mud*musd*sign(Ffric) ]; %
else
    
    % Stick Equation
    dydt = [v_d;
        -(y(2)-v_d)];
    
end

end

function Fatt = friction_law(vrel,mud,musd,muv,v0)

Fatt = mud + mud*(musd - 1)*exp(-abs(vrel)./v0) + muv*abs(vrel)./v0;    % Exponential decaying plus lineaar strengthening
% Fatt = mud*musd - 3/2*mud*(musd - 1)*((vrel./v0) - 1/3*(vrel./v0).^3).*sign(vrel); % polynomial, kind of Stribeck
% Fatt = mud;     % Simple Coulomb law

end