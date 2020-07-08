function [dydt] = ode_pendulum(t, y, alpha, T, K)
% ODE definition of the damped driven pendulum

% following the example given in the electronic supplementary information
% for the paper:
% [ Menck, Peter J., et al. "How basin stability complements the 
% linear-stability paradigm." Nature physics 9.2 (2013): 89-92. ]

% alpha: dissipation coefficient, default: 0.1
% T: constant angular acceleration, default: 0.5
% K: K=g/l, default: 1

% for 0<T<K the pendulum has two fixed points [phi, omega]:
% FP_phi_1 = asin(T/K);
% FP_phi_2 = pi-FP_phi_1;
% 
% FP_omega_1 = 0;
% FP_omega_2 = 0;

% There can also be a limit cycle solution for specific values of T, such
% that the system exhibits multistability


dydt = [y(2); 
        -alpha*y(2)+T-K*sin(y(1))];


end
