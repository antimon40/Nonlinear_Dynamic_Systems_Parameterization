%Simple test function
%x is a vector
%Y is a scalar
function y = f3(x)
    rho_m = 0.053;
    rho_c = rho_m/2;
    vf = 31.3;
    l = 500;
    alpha_j = 0.4;
    a = vf/(l*rho_c);
    y = a^2*(x(1)^2+alpha_j^2*x(2)^2+x(3)^2+x(4)^2);
end