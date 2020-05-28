% Function to represent system and observer models
% Observer design for nonlinear system by Zhang et. al.
% Author: Sebastian A. Nugroho
% Date: 6/7/2017

function [zdot] = system_model(t, z, sys, L)

% zdot: output variable and 't','z' are input variables
% xhat: estimated states
% model_2_2: function name
% Evaluates control input 'u' and nonlinearity 'f'
% Calculates system dynamics i.e., sys.A*x + sys.Bu*u + sys.Bf*f
% Calculates observer dynamics i.e.,  sys.A*xhat + sys.Bu*u + sys.Bf*fhat + sys.L*(y-sys.C*xhat)

%State
x = z(1:sys.dim.nx);
xhat = z(sys.dim.nx+1:end);

%Calculate f
f = zeros(sys.dim.nf,1);
for i = 1:sys.dim.nf
    f(i) = eval(sys.Phi{i});
end

%Calculate fhat
fhat = zeros(sys.dim.nf,1);
for i = 1:sys.dim.nf
    fhat(i) = eval(sys.Phihat{i});
end

%Disturbances
%wx = 0.01*(-1.0 + (1.0-(-1.0))*rand(size(sys.Bw,2),1));
wx = 1*sin(t);

%Attacks
%wy = 0.01*(-1.0 + (1.0-(-1.0))*rand(size(sys.Dw,2),1));
wy = 0.1*cos(4*t);

%Calculate xdot
xdot = sys.A*x + sys.Bf*f; % + sys.Bw*wx;

%Calculating output vector
y = sys.C*x; %+sys.Dw*wx;

%Calculate xhatdot
xhatdot = sys.A*xhat + sys.Bf*fhat + L*(y-sys.C*xhat);

%Calculate observer dynamics
zdot = [xdot; xhatdot];
end
