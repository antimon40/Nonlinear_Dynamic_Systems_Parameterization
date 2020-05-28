function out = moving_object_fun_inval(X,type_i,isMax)
%interval functions for each type of nonlinearity
%this returns the objective value evaluations (square of the norm of gradient vector)
%input: X is a cell of intervals, type_i is the type of nonlinearity
%one-sided Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

if isMax == 1 %upper bound
    switch type_i
        case 1
            Z1 = inv_mul_c(inv_pow(X{1},2),-3);
            Z2 = inv_pow(X{2},2);
            Z12 = inv_sub(Z1,Z2);
            Z3 = inv_abs(inv_mul_c(inv_mul(X{1},X{2}),-2));
            out = inv_add(Z12,Z3); 
        case 2
            Z1 = inv_mul_c(inv_pow(X{2},2),-3);
            Z2 = inv_pow(X{1},2);
            Z12 = inv_sub(Z1,Z2);
            Z3 = inv_abs(inv_mul_c(inv_mul(X{1},X{2}),-2));
            out = inv_add(Z12,Z3); 
        otherwise
            out = NaN;
    end
elseif isMax == 0 %lower bound
    switch type_i
        case 1
            Z1 = inv_mul_c(inv_pow(X{1},2),3);
            Z2 = inv_pow(X{2},2);
            Z12 = inv_add(Z1,Z2);
            Z3 = inv_abs(inv_mul_c(inv_mul(X{1},X{2}),-2));
            out = inv_add(Z12,Z3); 
        case 2
            Z1 = inv_mul_c(inv_pow(X{2},2),3);
            Z2 = inv_pow(X{1},2);
            Z12 = inv_add(Z1,Z2);
            Z3 = inv_abs(inv_mul_c(inv_mul(X{1},X{2}),-2));
            out = inv_add(Z12,Z3); 
        otherwise
            out = NaN;
    end 
elseif isMax == 0 %lower bound
    switch type_i
        case 1
            Z1 = inv_mul_c(inv_pow(X{1},2),3);
            Z2 = inv_pow(X{2},2);
            Z12 = inv_add(Z1,Z2);
            Z3 = inv_abs(inv_mul_c(inv_mul(X{1},X{2}),-2));
            out = inv_add(Z12,Z3); 
        case 2
            Z1 = inv_mul_c(inv_pow(X{2},2),3);
            Z2 = inv_pow(X{1},2);
            Z12 = inv_add(Z1,Z2);
            Z3 = inv_abs(inv_mul_c(inv_mul(X{1},X{2}),-2));
            out = inv_add(Z12,Z3); 
        otherwise
            out = NaN;
    end 
else %QIB Lipschitz
    switch type_i
        case 1
            Z1 = inv_mul_c(inv_pow(X{1},2),3);
            Z2 = inv_pow(X{2},2);
            Z12 = inv_pow(inv_add(Z1,Z2),2);
            Z3 = inv_pow(inv_mul_c(inv_mul(X{1},X{2}),2),2);
            out = inv_add(Z12,Z3); 
        case 2
            Z1 = inv_mul_c(inv_pow(X{2},2),3);
            Z2 = inv_pow(X{1},2);
            Z12 = inv_pow(inv_add(Z1,Z2),2);
            Z3 = inv_pow(inv_mul_c(inv_mul(X{1},X{2}),2),2);
            out = inv_add(Z12,Z3); 
        case 3
            Z1 = inv_mul_c(inv_pow(X{1},2),3);
            Z2 = inv_pow(X{2},2);
            Z12 = inv_pow(inv_add(Z1,Z2),2);
            Z3 = inv_pow(inv_mul_c(inv_mul(X{1},X{2}),2),2);
            out1 = inv_add(Z12,Z3);
            
            Z1 = inv_mul_c(inv_pow(X{2},2),3);
            Z2 = inv_pow(X{1},2);
            Z12 = inv_pow(inv_add(Z1,Z2),2);
            Z3 = inv_pow(inv_mul_c(inv_mul(X{1},X{2}),2),2);
            out2 = inv_add(Z12,Z3); 
            
            out = inv_add(out1,out2); 
        otherwise
            out = NaN;
    end     
end

end