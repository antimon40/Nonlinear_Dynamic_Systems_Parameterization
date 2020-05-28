function out = traffic_fun(x,param,type)
%scalar functions for each type of nonlinearity
%this returns the objective values (square of the norm of gradient vector)
%input: x is the vector, param is the traffic model parameter, type is the type of nonlinearity
%Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

switch type
    case 1 %a
        out = 4*(param.a)^2*x(1)^2;
    case 2 %b
        out = 4*(param.a)^2*(x(1)^2+x(2)^2+x(3)^2);
    case 3 %c
        out = 4*(param.a)^2*(x(1)^2+x(2)^2);
    case 4 %d
        out = 4*(param.a)^2*(x(1)^2+x(2)^2+(param.alpha_j)^2*x(3)^2);
    case 5 %e
        out = 4*(param.a)^2*(param.alpha_j)^2*x(1)^2;
    otherwise
        out = NaN;
end


end