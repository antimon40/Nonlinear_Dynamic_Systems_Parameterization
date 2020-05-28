function val = fnonlin_one_generator_h(x,u,c)
%Nonlinear function h(x,u) of one generator model as it appears in the
%state equation
%Input: x is the state vector, u is the input vector, c is the constant
%parameters
%Author: Sebastian A. Nugroho
%Date: 9/12/2018

%With disturbance
u = [0; 0; u(1); u(2)];

%The function
h1 = x(3)*cos(x(1))+x(4)*sin(x(1))+c.b_1*u(3)*sin(2*x(1))+c.b_1*u(4)*cos(2*x(1));
h2 = x(3)*sin(x(1))-x(4)*cos(x(1))-c.b_1*u(3)*cos(2*x(1))-c.b_1*u(4)*sin(2*x(1));

val = [h1; h2];
end