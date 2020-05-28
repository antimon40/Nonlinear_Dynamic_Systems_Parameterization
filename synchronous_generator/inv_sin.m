function Z = inv_sin(X,n)
%input: X is an interval on real, where X = [x_l x_u], n is integer to
%adjust the accuracy of the approximation of upper and lower bound
%output: Z is an interval where Z = X^n, Z = [z_l z_u]
%Interval arithmetic for sin
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

%Approximate the upper and lower bound of pi
pi_ub = appr_pi(n,'ub');
pi_lb = appr_pi(n,'lb');

if (-pi_lb/2 <= X(1)) && (X(2) <= pi_lb/2)
    Z(1) = appr_sin(X(1),n,'lb');
    Z(2) = appr_sin(X(2),n,'ub');
elseif (pi_ub/2 <= X(1)) && (X(2) <= pi_lb)
    Z(1) = appr_sin(X(2),n,'lb');
    Z(2) = appr_sin(X(1),n,'ub');
elseif (0 <= X(1)) && (X(2) <= pi_lb)
    Z(1) = min(appr_sin(X(1),n,'lb'),appr_sin(X(2),n,'lb'));
    Z(2) = 1;
elseif (-pi_lb <= X(1)) && (X(2) <= 0)
    Z = inv_neg(inv_sin(inv_neg(X),n)); %recursive
else
    Z = [-1 1];
end
end
    