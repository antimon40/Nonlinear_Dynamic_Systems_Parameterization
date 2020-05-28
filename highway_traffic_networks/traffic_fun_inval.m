function out = traffic_fun_inval(X,param,type)
%interval functions for each type of nonlinearity
%this returns the objective value evaluations (square of the norm of gradient vector)
%input: X is a cell of intervals, param is the traffic model parameter, type is the type of nonlinearity
%Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

switch type
    case 1 %a
        Z1 = inv_pow(X{1},2);
        out = inv_mul_c(Z1,4*(param.a)^2);
    case 2 %b
        Z1 = inv_pow(X{1},2);
        Z2 = inv_pow(X{2},2);
        Z3 = inv_pow(X{3},2);
        Z = inv_add(Z1,inv_add(Z2,Z3));
        out = inv_mul_c(Z,4*(param.a)^2);
    case 3 %c
        Z1 = inv_pow(X{1},2);
        Z2 = inv_pow(X{2},2);
        Z = inv_add(Z1,Z2);
        out = inv_mul_c(Z,4*(param.a)^2);
    case 4 %d
        Z1 = inv_pow(X{1},2);
        Z2 = inv_pow(X{2},2);
        Z3 = inv_mul_c(inv_pow(X{3},2),(param.alpha_j)^2);
        Z = inv_add(Z1,inv_add(Z2,Z3));
        out = inv_mul_c(Z,4*(param.a)^2);
    case 5 %e
        Z1 = inv_pow(X{1},2);
        out = inv_mul_c(Z1,4*(param.a)^2*(param.alpha_j)^2);
    otherwise
        out = NaN;
end

end