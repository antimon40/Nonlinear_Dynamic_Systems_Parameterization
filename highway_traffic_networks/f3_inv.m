%Simple test function
%X is a cell of intervals
%Y is an interval
function Y = f3_inv(X)
    rho_m = 0.053;
    rho_c = rho_m/2;
    vf = 31.3;
    l = 500;
    alpha_j = 0.4;
    a = vf/(l*rho_c);
    Z1 = inv_pow(X{1},2);
    Z2 = inv_mul_c(inv_pow(X{2},2),alpha_j^2);
    Z12 = inv_add(Z1,Z2);
    Z3 = inv_pow(X{3},2);
    Z4 = inv_pow(X{4},2);
    Z34 = inv_add(Z3,Z4);
    Z = inv_add(Z12,Z34);
    Y = inv_mul_c(Z,a^2);
end