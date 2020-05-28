% Main Program
% By: Sebastian A. Nugroho
% Date: 6/7/2017

clear 
close all

%Describe the system matrices
[sys] = system_matrix();

%Obtain the observer gain L
disp(' ');
disp('Solving LMIs...')

%Constants
epsilon = 10^-15;

%Variables
P = sdpvar(sys.dim.nx,sys.dim.nx,'symmetric');
eps1 = sdpvar(1);
eps2 = sdpvar(1);
sigma = sdpvar(1);

%Objective functions
obj = [];

%Constraint #1
F1 = [sys.A'*P+P*sys.A+(eps1*sys.lipc.rho+eps2*sys.lipc.delta)*eye(sys.dim.nx)-sigma*sys.C'*sys.C ...
      P+(1/2)*(sys.lipc.phi*eps2-eps1)*eye(sys.dim.nx);
      P+(1/2)*(sys.lipc.phi*eps2-eps1)*eye(sys.dim.nx) -eps2*eye(sys.dim.nx)] + eps*eye(2*sys.dim.nx) <= 0;
%Constraint #2
F2 = [P >= epsilon*eye(sys.dim.nx), eps1 >= epsilon, eps2 >= epsilon, sigma >= eps];

%YALMIP settings
ops = sdpsettings('verbose',1,'solver','mosek');

%Solve the optimization problem
tic;
sol = optimize([F1,F2], obj, ops);
disp(' ');
disp('Solving LMIs is done')
fprintf(1, '\nStatus of the LMI solver: %s', sol.info); 
elapsedTime = toc;

%Calculating observer gain
if (sol.problem ~= 1)
    L = (value(sigma)/2)*inv(value(P))*sys.C';
else
    L = zeros(sys.dim.nx,sys.dim.ny);
end

%Simulate the result
system_simul(sys,L);
