function val = fnonlin_one_generator_f(x,u,c)
%Nonlinear function f(x,u) of one generator model as it appears in the
%state equation
%Input: x is the state vector, u is the input vector, c is the constant
%parameters
%Author: Sebastian A. Nugroho
%Date: 9/12/2018

% %Specify the constant parameters
% omega_0 = 2*pi*60; %steady state rotor speed (rad/s)
% K_D_i = 0.05; %damping factor
% H_i = 2.8765; %inertia constant
% S_B = 100; %system base (MVA)
% S_N = 991; %generator base (MVA)
% Tpo_q = 0.66; %open circuit time constants in q axis
% Tpo_d = 5; %open circuit time constants in d axis
% x_q = 1.91; %synchronous reactance in q axis
% x_d = 2; %synchronous reactance in d axis
% xp_q = 0.245; %transient reactance in q axis
% xp_d = 0.245; %transient reactance in d axis
% 
% %Wrap the parameters
% a_1 = omega_0;
% a_2 = omega_0/(2*H_i);
% a_3 = (omega_0/(2*H_i))*(S_B/S_N)^2;
% a_4 = (omega_0/(2*H_i))*(S_B/S_N)^3*(xp_q-xp_d);
% a_5 = K_D_i/(2*H_i);
% a_6 = (K_D_i/(2*H_i))*omega_0;
% a_7 = 1/Tpo_d;
% a_8 = (1/Tpo_d)*(S_B/S_N)*(x_d-xp_d);
% a_9 = 1/Tpo_q;
% a_10 = (1/Tpo_d)*(S_B/S_N)*(x_q-xp_q);

%With disturbance
u = [0; 0; u(1); u(2)];

%The function
f1 = -c.a_1;
f2 = c.a_3*x(4)*u(4)*cos(x(1))-c.a_3*x(3)*u(4)*sin(x(1))-c.a_3*x(4)*u(3)*sin(x(1))...
     -c.a_3*x(3)*u(3)*cos(x(1))+c.a_4*u(3)*u(4)*cos(2*x(1))+(1/2)*c.a_4*(u(4)^2-u(3)^2)*sin(2*x(1))+c.a_6;
f3 = c.a_8*u(4)*cos(x(1))-c.a_8*u(3)*sin(x(1));
f4 = c.a_10*u(3)*cos(x(1))+c.a_10*u(4)*sin(x(1));

val = [f1; f2; f3; f4];
end