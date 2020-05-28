% Main program for DSE of one generator model under fault
% Scenario: use Rajamani's observer, linearize h(x,u) around initial
% conditions
% Author: Sebastian A. Nugroho
% Date: 9/19/2018

clear
close all

%Load simulation data from PST
filename = strcat('data_simulation_one_generator_fault_gen_14.mat');
load(filename);

%Get generator parameter
param = one_generator_parameter(alpha,beta,x_min,x_max,u_min,u_max);

%Number of states 
Nx = size(param.Dx,1);

%Number of inputs
Nu = size(param.Du,1);

%Compute jacobian matrix
%Variables
xsym = sym('xsym', [Nx 1], 'real');
usym = sym('usym', [Nu 1] ,'real');

%nonlinear function
fnonlin = fnonlin_one_generator_h(xsym,usym,param);

%Compute Jacobian matrix
Jmx = jacobian(fnonlin,xsym);
Jmu = jacobian(fnonlin,usym);

%Linearized matrix
Jmvx = subs(Jmx,xsym,x0);
Jmvx = subs(Jmvx,usym,u0);
Jmvu = subs(Jmu,xsym,x0);
Jmvu = subs(Jmvu,usym,u0);
C = double(vpa(Jmvx));
Du = Du + double(vpa(Jmvu));

%Obtain observer gain matrix L
%Define dimenstions
n = size(A,1);
m = size(Bu,2);
p  =size(C,1);

%Choose Lipschitz constant
lipf = 11.5593;

%Constant for positive definiteness
eps1 = 10^-14;
eps2 = 10^-14;

%Add YALMIP's path
%addpath(genpath('C:\Research\YALMIP-master\YALMIP-master'));
% addpath(genpath('C:\Users\sanugroho\Documents\YALMIP-master\YALMIP-master'));

%Optimization variables
P = sdpvar(n,n,'symmetric');
Y = sdpvar(n,p);
epsilon = sdpvar(1);

%Objective functions
obj = 0;

%Constraints for the first optimization problem
%Constraint #1
F1 = [A'*P + P*A - C'*Y' - Y*C + epsilon*lipf^2*eye(n) P;
      P -epsilon*eye(n)] + eps1*eye(n+n) <= 0;
%Constraint #2
F2 = [P >= eps2*eye(n), epsilon >= 0];

%YALMIP settings
ops = sdpsettings('verbose',1,'solver','mosek');

%Solve the optimization problem
disp('Solving LMIs...');
tic;
sol = optimize([F1 F2], obj, ops);
elapsedTime = toc;
disp('Done!');
fprintf(1, 'Computation time: %f seconds', elapsedTime); 
fprintf(1, '\nYALMIP status: %s', sol.info); 
fprintf('\n');

%Compute observer gain matrix 
L = inv(value(P))*value(Y);

%Observer's initial condition
%x0_obs = [0.5; 376; 1.12; 0.21];
x0_obs = x0 + 7*[0.07 -0.3 0.02 -0.03]';

%Initialize vector for ODE simulation
DeltaT = diff(tspan);

%ODE solver
[t, x_ode] = ode15s(@(t,x_ode) one_generator_dynamics(x_ode,u,A,Bu,C,Du,L,...
    n,m,p,param,DeltaT,t,tspan), tspan, [x0; x0_obs]');
x_sys(:,1:n) = x_ode(:,1:n);
x_obs(:,1:n) = x_ode(:,n+1:end);

%Plot system's vs observer's trajectories
fs = 18;
h(1) = figure;
set(gcf,'numbertitle','off','name','System and Observer Trajectory')
%title('Rotor Angle')
hold on
p1a = plot(t,x_sys(:,1),'LineWidth',2.5);
p1b = plot(t,x_obs(:,1),'LineStyle','-.','LineWidth',2.5);
hold off
box on
grid off
xlabel('$t$ (seconds)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('Rotor Angle $\delta$ \textrm{(rad)}', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
legend(gca,[p1a p1b],{'$x_1(t)$','$\hat{x}_1(t)$'},...
    'location','best','interpreter','latex','FontName','Times New Roman','FontSize',fs);
set(gcf,'color','w');
legend boxoff;
set(gca,'fontsize',18);
set(h(1), 'Position', [100 0 500 370])
print(h(1), 'state_angle.eps', '-depsc2','-r600')

h(2) = figure;
set(gcf,'numbertitle','off','name','System and Observer Trajectory')
%title('Rotor Speed')
hold on
p2a = plot(t,x_sys(:,2)/2/pi,'LineWidth',2.5);
p2b = plot(t,x_obs(:,2)/2/pi,'LineStyle','-.','LineWidth',2.5);
hold off
box on
grid off
xlabel('$t$ (seconds)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('Rotor Speed $\omega$ \textrm{(Hz)}', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
legend(gca,[p2a p2b],{'$x_2(t)$','$\hat{x}_2(t)$'},...
    'location','best','interpreter','latex','FontName','Times New Roman','FontSize',fs);
set(gcf,'color','w');
legend boxoff;
set(gca,'fontsize',18);
set(h(2), 'Position', [100 0 500 370])
print(h(2), 'state_freq.eps', '-depsc2','-r600')
