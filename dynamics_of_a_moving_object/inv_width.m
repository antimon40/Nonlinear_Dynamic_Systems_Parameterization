function y = inv_width(X)
%input: X is an interval on real, where X = [x_l x_u]
%output: y = x_u - x_l
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

    y = X(2) - X(1);
end