function z = appr_cos(x,n,type)
%input: x is a real number, n determines the
%accuracy of the approximation, type is either 'ub' or 'lb'
%output: z is a real number
%Function to approximate the upper and lower bound of cos
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

%Define m
if x < 0
    m = 2*n;
    if isequal(type,'ub')
        max_iter = m;
        sum = 0;
        for i = 1:max_iter
            temp = ((-1)^(i))*(x^(2*i))/factorial(2*i);
            sum = sum + temp;
        end
        z = 1 + sum;
    elseif isequal(type,'lb')
        max_iter = m + 1;
        sum = 0;
        for i = 1:max_iter
            temp = ((-1)^(i))*(x^(2*i))/factorial(2*i);
            sum = sum + temp;
        end
        z = 1 + sum;
    else
        z = NaN;
    end
else
    m = 2*n + 1;
    if isequal(type,'ub')
        max_iter = m + 1;
        sum = 0;
        for i = 1:max_iter
            temp = ((-1)^(i))*(x^(2*i))/factorial(2*i);
            sum = sum + temp;
        end
        z = 1 + sum;
    elseif isequal(type,'lb')
        max_iter = m;
        sum = 0;
        for i = 1:max_iter
            temp = ((-1)^(i))*(x^(2*i))/factorial(2*i);
            sum = sum + temp;
        end
        z = 1 + sum;
    else
        z = NaN;
    end
end


end