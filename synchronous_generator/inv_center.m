function y = inv_center(X)
%input: X is an interval on real, where X = [x_l x_u]
%output: y = (1/2)*(x_l + x_u)
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

    y = (1/2)*(X(1) + X(2));
end