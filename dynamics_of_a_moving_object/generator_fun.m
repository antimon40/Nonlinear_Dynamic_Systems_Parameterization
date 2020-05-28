function out = generator_fun(x,param,type)
%scalar functions for each type of nonlinearity
%this returns the objective values (square of the norm of gradient vector)
%input: x is the vector, param is the generator model parameter, type is the type of nonlinearity
%Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

switch type
    case 2
        df_dx1 = param.a_3*((-x(2)*x(5)-x(3)*x(4))*sin(x(1)) + (x(3)*x(5)-x(2)*x(4))*cos(x(1))) ... 
                    + param.a_4*(-2*x(4)*x(5)*sin(2*x(1)) + (1/2)*(x(5)^2-x(4)^2)*cos(2*x(1)));
        df_dx3 = -param.a_3*(x(5)*sin(x(1)) + x(4)*cos(x(1)));
        df_dx4 = -param.a_3*(x(4)*sin(x(1)) - x(5)*cos(x(1)));
        out = df_dx1^2 + df_dx3^2 + df_dx4^2;
    case 3
        out = (param.a_8)^2*(x(3)*sin(x(1))-x(2)*cos(x(1)))^2;
    case 4
        out = (param.a_10)^2*(x(2)*sin(x(1))+x(3)*cos(x(1)))^2;
    otherwise
        out = NaN;
end

end