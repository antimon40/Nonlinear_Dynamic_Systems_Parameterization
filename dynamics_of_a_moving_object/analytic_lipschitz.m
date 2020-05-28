function lip = analytic_lipschitz(c,f_type)
%Analytically compute Lipschitz constant based on single generator parameter
%Input: generator constants and parameters as c,
%       function type as f_type, i.e. 'f' or 'h'
%Output: lipschitz constant of 'f' or 'h' as lip
%Author: Sebastian A. Nugroho
%Date: 9/13/2018

%Auxiliary max function
k = @(z1,z2) max(abs(z1),abs(z2));

%Compute Lipschitz constants
if isequal(f_type,'f') == 1
    yt_f = abs(c.a_3)*((k(c.Du(3,1),c.Du(3,2))+k(c.Du(4,1),c.Du(4,2)))*...
            (1+k(c.Dx(3,1),c.Dx(3,2))+k(c.Dx(4,1),c.Dx(4,2)))+...
            2*k(c.Du(3,1),c.Du(3,2))*k(c.Du(4,1),c.Du(4,2)))+...
            abs(c.a_4)*(k(c.Du(3,1),c.Du(3,2))*(1+k(c.Du(3,1),c.Du(3,2)))+...
            k(c.Du(4,1),c.Du(4,2))*(1+k(c.Du(4,1),c.Du(4,2))));
    lip = sqrt(yt_f^2+(abs(c.a_8)^2+abs(c.a_10)^2)*...
        (k(c.Du(3,1),c.Du(3,2))+k(c.Du(4,1),c.Du(4,2)))^2);    
elseif isequal(f_type,'h') == 1
    lip = sqrt(2)*(k(c.Dx(3,1),c.Dx(3,2))+k(c.Dx(3,1),c.Dx(3,2))+...
        2*abs(c.b_1)*(k(c.Du(3,1),c.Du(3,2))+k(c.Du(4,1),c.Du(4,2)))+sqrt(2));
end

end