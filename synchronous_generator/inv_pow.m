function Z = inv_pow(X,n)
%input: X is an interval on real, where X = [x_l x_u], n is the power
%output: Z is an interval where Z = X^n, Z = [z_l z_u]
%Interval arithmetic for power
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

if n == 0
    Z(1) = 1;
    Z(2) = 1;
elseif (X(1) >= 0) || (mod(n,2)== 1)
    Z(1) = X(1)^n;
    Z(2) = X(2)^n;
elseif (X(2) <= 0) && (mod(n,2)== 0)
    Z(1) = X(2)^n;
    Z(2) = X(1)^n;
elseif (X(1) <= 0) && (0 <= X(2)) && (n > 0) && (mod(n,2)== 0)
    Z(1) = 0;
    Z(2) = max(X(1)^n,X(2)^n);
else
    Z = [NaN NaN];
end
end
    