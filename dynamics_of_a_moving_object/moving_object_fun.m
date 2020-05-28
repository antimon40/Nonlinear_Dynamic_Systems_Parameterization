function out = moving_object_fun(x,type_i,isMax)
%scalar functions for each type of nonlinearity
%this returns the objective values (square of the norm of gradient vector)
%input: x is the vector, type_i is the type of nonlinearity
%one-sided Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

if isMax == 1 %upper bound
    switch type_i
        case 1
            out = -3*x(1)^2-x(2)^2+abs(-2*x(1)*x(2)); 
        case 2
            out = -3*x(2)^2-x(1)^2+abs(-2*x(1)*x(2)); 
        otherwise
            out = NaN;
    end
elseif isMax == 0 %lower bound
    switch type_i
        case 1
            out = 3*x(1)^2+x(2)^2+abs(-2*x(1)*x(2)); 
        case 2
            out = 3*x(2)^2+x(1)^2+abs(-2*x(1)*x(2)); 
        otherwise
            out = NaN;
    end  
else %QIB Lipschitz
    switch type_i
        case 1
            out = (3*x(1)^2+x(2)^2)^2+(2*x(1)*x(2))^2; 
        case 2
            out = (3*x(2)^2+x(1)^2)^2+(2*x(1)*x(2))^2; 
        case 3
            out = (3*x(1)^2+x(2)^2)^2+(2*x(1)*x(2))^2 + (3*x(2)^2+x(1)^2)^2+(2*x(1)*x(2))^2;
        otherwise
            out = NaN;
    end 
end

end