function Z = inv_abs(X)
%input: X is an interval on real, where X = [x_l x_u]
%output: Z is an interval where Z = abs(X)
%Interval arithmetic for absolute value
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

    if (X(1)*X(2)) >= 0
        Z(1) = min([abs(X(1)) abs(X(2))]);
        Z(2) = max([abs(X(1)) abs(X(2))]);
    else
        Z(1) = 0;
        Z(2) = max([abs(X(1)) abs(X(2))]);
    end

end