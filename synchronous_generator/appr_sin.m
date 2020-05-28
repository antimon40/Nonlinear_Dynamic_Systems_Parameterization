function z = appr_sin(x,n,type)
%input: x is a real number, n determines the
%accuracy of the approximation, type is either 'ub' or 'lb'
%output: z is a real number
%Function to approximate the upper and lower bound of sin
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

%Define m
if x < 0
    m = 2*n;
else
    m = 2*n + 1;
end

if isequal(type,'ub')
    max_iter = m;
    sum = 0;
    for i = 1:max_iter
        temp = ((-1)^(i-1))*(x^(2*i-1))/factorial(2*i-1);
        sum = sum + temp;
    end
    z = sum;
elseif isequal(type,'lb')
    max_iter = m+1;
    sum = 0;
    for i = 1:max_iter
        temp = ((-1)^(i-1))*(x^(2*i-1))/factorial(2*i-1);
        sum = sum + temp;
    end
    z = sum;
else
    z = NaN;
end

end