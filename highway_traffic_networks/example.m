
%Domain
X = [-2 3];

%x^3-1
Z1 = inv_pow(X,3);
Z2 = inv_sub(Z1,[1 1]);
result1 = Z2

%(x-1)(x^2 + x + 1)
Z11 = inv_pow(X,2);
Z12 = inv_add(Z11,X);
Z13 = inv_add(Z12,[1 1]);
Z21 = inv_sub(X,[1 1]);
Z3 = inv_mul(Z13,Z21);
result2 = Z3


