function Z = inv_div(X,Y)
%input: X and Y are intervals on real, where X = [x_l x_u], Y = [y_l y_u]
%output: Z is an interval where Z = X / Y, Z = [z_l z_u]
%warning: 0 does not belong in Y, y_l > 0 or y_u < 0,
%Interval arithmetic basic division
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

if (Y(1) > 0) || (Y(2) < 0)
    Yinv = [1/Y(2) 1/Y(1)];

    v = [X(1)*Yinv(1) X(1)*Yinv(2) X(2)*Yinv(1) X(2)*Yinv(2)];

    Z(1) = min(v);
    Z(2) = max(v);
else
    Z(1) = NaN;
    Z(2) = NaN;
end
end