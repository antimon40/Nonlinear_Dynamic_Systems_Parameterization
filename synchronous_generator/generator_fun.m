function out = generator_fun(x,param,type)
%scalar functions for each type of nonlinearity
%this returns the objective values (square of the norm of gradient vector)
%input: x is the vector, param is the generator model parameter, type is the type of nonlinearity
%Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

    df2_dx1 = -param.a_3*((x(4)*x(6)-x(3)*x(5))*sin(x(1)) + (x(3)*x(6)+x(4)*x(5))*cos(x(1))) ...
             -param.a_4*(2*x(5)*x(6)*sin(x(1)) - (1/2)*(x(6)^2-x(5)^2)*cos(2*x(1)));
    df2_dx3 = -param.a_3*(x(6)*sin(x(1)) + x(5)*cos(x(1)));
    df2_dx4 = -param.a_3*(x(5)*sin(x(1)) - x(6)*cos(x(1)));
    df3_dx1 = -param.a_8*(x(6)*sin(x(1)) + x(5)*cos(x(1)));
    df4_dx1 = -param.a_10*(x(5)*sin(x(1)) - x(6)*cos(x(1)));

    out = df2_dx1^2 + df2_dx3^2 + df2_dx4^2 + df3_dx1^2 + df4_dx1^2;

end