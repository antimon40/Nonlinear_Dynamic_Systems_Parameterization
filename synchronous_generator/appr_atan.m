function z = appr_atan(x,n,type)
%input: x is a real number, n determines the
%accuracy of the approximation, type is either 'ub' or 'lb'
%output: z is a real number
%Function to approximate the upper and lower bound of atan
%Warning: x must satisfy 0 < x <= 1
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

if (0 < x) && (x <= 1)
    if isequal(type,'ub')
        max_iter = 2*n;
        sum = 0;
        for i = 0:max_iter
            temp = (x^(2*i+1))*(((-1)^i)/(2*i+1));
            sum = sum + temp;
        end
        z = sum;
    elseif isequal(type,'lb')
        max_iter = 2*n+1;
        sum = 0;
        for i = 0:max_iter
            temp = (x^(2*i+1))*((-1)^i/(2*i+1));
            sum = sum + temp;
        end
        z = sum;
    else
        z = NaN;
    end
else
    z = NaN;
end

end