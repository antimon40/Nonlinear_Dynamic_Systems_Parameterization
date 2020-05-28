function out = generator_fun_inval(X,param,type)
%interval functions for each type of nonlinearity
%this returns the objective value evaluations (square of the norm of gradient vector)
%input: X is a cell of intervals, param is the generator model parameter, type is the type of nonlinearity
%Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

%Accuracy
n = 4;

switch type
    case 2
        A11 = inv_neg(inv_mul(X{2},X{5}));
        A12 = inv_neg(inv_mul(X{3},X{4}));
        A13 = inv_add(A11,A12);
        A14 = inv_mul(A13,inv_sin(X{1},n));
        A21 = inv_mul(X{3},X{5});
        A22 = inv_neg(inv_mul(X{2},X{4}));
        A23 = inv_add(A21,A22);
        A24 = inv_mul(A23,inv_cos(X{1},n));
        A3 = inv_mul_c(inv_add(A14,A24),param.a_3); 
        A41 = inv_mul_c(inv_mul(X{4},X{5}),-2);
        A42 = inv_mul(A41,inv_sin(inv_mul_c(X{1},2),n));
        A51 = inv_mul_c(inv_sub(inv_pow(X{5},2),inv_pow(X{4},2)),(1/2));
        A52 = inv_mul(A51,inv_cos(inv_mul_c(X{1},2),n));
        A6 = inv_mul_c(inv_add(A42,A52),param.a_4); 
        A = inv_add(A3,A6);
        
        B11 = inv_sin(X{1},n);
        B12 = inv_mul(X{5},B11);
        B21 = inv_cos(X{1},n);
        B22 = inv_mul(X{4},B21);
        B3 = inv_add(B12,B22);
        B = inv_mul_c(B3,-param.a_3);
        
        C11 = inv_sin(X{1},n);
        C12 = inv_mul(X{4},C11);
        C21 = inv_cos(X{1},n);
        C22 = inv_mul(X{5},C21);
        C3 = inv_sub(C12,C22);
        C = inv_mul_c(C3,-param.a_3);
        
        out = inv_add(inv_add(inv_pow(A,2),inv_pow(B,2)),inv_pow(C,2));
    case 3
        Z11 = inv_sin(X{1},n);
        Z12 = inv_mul(X{3},Z11);
        Z21 = inv_cos(X{1},n);
        Z22 = inv_mul(X{2},Z21);
        Z3 = inv_sub(Z12,Z22);
        Z4 = inv_pow(Z3,2);
        out = inv_mul_c(Z4,(param.a_8)^2);
    case 4
        Z11 = inv_sin(X{1},n);
        Z12 = inv_mul(X{2},Z11);
        Z21 = inv_cos(X{1},n);
        Z22 = inv_mul(X{3},Z21);
        Z3 = inv_add(Z12,Z22);
        Z4 = inv_pow(Z3,2);
        out = inv_mul_c(Z4,(param.a_10)^2);
    otherwise
        out = NaN;
end

end