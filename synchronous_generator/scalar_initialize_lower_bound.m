function [out] = scalar_initialize_lower_bound(S,param,type)
%input: S is a hyperrectangle, param is the traffic model parameter, type is the type of nonlinearity
%output: out is a scalar
%description: initialize lower bound
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

%Dimension of hyperrectangle S
dim = length(S.h.dim);

% %Create vector
% x_left = [];
% for i = 1:dim
%     x_left = [x_left; S.h.dim(i).l]; %left point
% end
% 
% %Evaluate x left
% if isequal(fun_mode,'c') == 1
%     out_l = traffic_fun(x_left,param,type);
% else
%     out_l = traffic_fun_prop1(x_left,param,param.E_N);
% end
% 
% %Create vector
% x_right = [];
% for i = 1:dim
%     x_right = [x_right; S.h.dim(i).u]; %right point
% end
% 
% %Evaluate x left
% if isequal(fun_mode,'c') == 1
%     out_r = traffic_fun(x_right,param,type);
% else
%     out_r = traffic_fun_prop1(x_right,param,param.E_N);
% end
% 
% out = max(out_l,out_r);

%Create vector
x = [];
for i = 1:dim
    x = [x; mean([S.h.dim(i).l S.h.dim(i).u])]; %middle point
end

%Evaluate x
out = generator_fun(x,param,type);

% %Evaluate x
% if isequal(fun_mode,'c') == 1
%     out = traffic_fun(x,param,type);
% else
%     out = traffic_fun_prop1(x,param,param.E_N);
% end

end