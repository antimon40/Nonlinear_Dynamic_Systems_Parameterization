function Z = inv_mul_c(X,c)
%input: X is an interval on real, where X = [x_l x_u], c is a constant
%output: Z is an interval where Z = c * X, Z = [z_l z_u]
%Interval arithmetic basic multiplication with constant
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

if c >= 0
    Z(1) = c*X(1);
    Z(2) = c*X(2);
else
    Z(1) = c*X(2);
    Z(2) = c*X(1);
end
end