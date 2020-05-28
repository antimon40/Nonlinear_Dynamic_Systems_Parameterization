function Z = inv_add(X,Y)
%input: X and Y are intervals on real, where X = [x_l x_u], Y = [y_l y_u]
%output: Z is an interval where Z = X + Y, Z = [z_l z_u]
%Interval arithmetic basic addition
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

    Z(1) = X(1) + Y(1);
    Z(2) = X(2) + Y(2);
end