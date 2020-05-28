function Z = inv_mul(X,Y)
%input: X and Y are intervals on real, where X = [x_l x_u], Y = [y_l y_u]
%output: Z is an interval where Z = X * Y, Z = [z_l z_u]
%Interval arithmetic basic multiplication
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

    v = [X(1)*Y(1) X(1)*Y(2) X(2)*Y(1) X(2)*Y(2)];

    Z(1) = min(v);
    Z(2) = max(v);
end