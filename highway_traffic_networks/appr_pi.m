function z = appr_pi(n,type)
%input: n determines the accuracy of the approximation, type is either 'ub' or 'lb'
%output: z is a real number
%Function to approximate the upper and lower bound of pi
%Warning: x must satisfy 0 < x <= 1
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

if isequal(type,'ub')
    z = 16*appr_atan(1/5,n,'ub') - 4*appr_atan(1/239,n,'lb');
elseif isequal(type,'lb')
    z = 16*appr_atan(1/5,n,'lb') - 4*appr_atan(1/239,n,'ub');
else
    z = NaN;
end

end