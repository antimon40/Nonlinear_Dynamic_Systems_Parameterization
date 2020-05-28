function Z = inv_inv(X)
%input: X is an interval on real, where X = [x_l x_u]
%output: Z is an interval where Z = 1 / X, Z = [z_l z_u]
%warning: 0 does not belong in X, x_l > 0, x_u < 0,
%Interval arithmetic multiplicative inverse
%Author: Sebastian A. Nugroho
%Date: 1/31/2019
if (X(1) > 0) || (X(2) < 0)
    Z = [1/X(2) 1/X(1)];
else
    Z = [NaN NaN];
end
end