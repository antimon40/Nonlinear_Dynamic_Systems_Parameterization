function out = generator_fun_inval(X,param,type)
%interval functions for each type of nonlinearity
%this returns the objective value evaluations (square of the norm of gradient vector)
%input: X is a cell of intervals, param is the generator model parameter, type is the type of nonlinearity
%Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

%Accuracy
n = 4;

A11 = inv_mul(X{4},X{6});
A12 = inv_mul(X{3},X{5});
A13 = inv_sub(A11,A12);
A14 = inv_mul(A13,inv_sin(X{1},n));
A21 = inv_mul(X{3},X{6});
A22 = inv_mul(X{4},X{5});
A23 = inv_add(A21,A22);
A24 = inv_mul(A23,inv_cos(X{1},n));
A3 = inv_mul_c(inv_add(A14,A24),-param.a_3); 
A41 = inv_mul_c(inv_mul(X{5},X{6}),2);
A42 = inv_mul(A41,inv_sin(inv_mul_c(X{1},2),n));
A51 = inv_mul_c(inv_sub(inv_pow(X{6},2),inv_pow(X{5},2)),(1/2));
A52 = inv_mul(A51,inv_cos(inv_mul_c(X{1},2),n));
A6 = inv_mul_c(inv_sub(A42,A52),-param.a_4); 
df2_dx1 = inv_add(A3,A6);

B11 = inv_mul(X{6},inv_sin(X{1},n));
B12 = inv_mul(X{5},inv_cos(X{1},n));
B13 = inv_add(B11,B12);
df2_dx3 = inv_mul_c(B13,-param.a_3);

C11 = inv_mul(X{5},inv_sin(X{1},n));
C12 = inv_mul(X{6},inv_cos(X{1},n));
C13 = inv_sub(C11,C12);
df2_dx4 = inv_mul_c(C13,-param.a_3);

% D11 = inv_mul(X{6},inv_sin(X{1},n));
% D12 = inv_mul(X{5},inv_cos(X{1},n));
% D13 = inv_add(D11,D12);
df3_dx1 = inv_mul_c(B13,-param.a_8);

% E11 = inv_mul(X{5},inv_sin(X{1},n));
% E12 = inv_mul(X{6},inv_cos(X{1},n));
% E13 = inv_sub(E11,E12);
df4_dx1 = inv_mul_c(C13,-param.a_10);

df2_dx1_sqr = inv_pow(df2_dx1,2);
df2_dx3_sqr = inv_pow(df2_dx3,2);
df2_dx4_sqr = inv_pow(df2_dx4,2);
df3_dx1_sqr = inv_pow(df3_dx1,2);
df4_dx1_sqr = inv_pow(df4_dx1,2);

out = inv_add(df4_dx1_sqr,inv_add(inv_add(df2_dx1_sqr,df2_dx3_sqr),inv_add(df2_dx4_sqr,df3_dx1_sqr)));

end