function Z = inv_add_c(X,c)
%input: X is an interval on real, where X = [x_l x_u], c is a constant
%output: Z is an interval where Z = X + c, Z = [z_l z_u]
%Interval arithmetic basic addition with constant
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

    Z(1) = X(1) + c;
    Z(2) = X(2) + c;
end