function Z = inv_sqrt(X)
%input: X is an interval on real, where X = [x_l x_u]
%output: Z is an interval where Z = sqrt(X), Z = [z_l z_u]
%warning: x_l > 0
%Interval arithmetic multiplicative inverse
%Author: Sebastian A. Nugroho
%Date: 1/31/2019
if (X(1) >= 0) 
    Z = [sqrt(X(1)) sqrt(X(2))];
else
    Z = [NaN NaN];
end
end