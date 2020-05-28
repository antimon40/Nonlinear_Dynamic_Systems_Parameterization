function Z = inv_neg(X)
%input: X is an interval on real, where X = [x_l x_u]
%output: Z is an interval where Z = -X, Z = [z_l z_u]
%Interval arithmetic for multiplication with -1
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

Z(1) = -X(2);
Z(2) = -X(1);

end