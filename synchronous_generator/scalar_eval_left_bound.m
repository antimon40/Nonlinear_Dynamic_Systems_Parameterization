function [out] = scalar_eval_left_bound(S,param,type,fun_mode)
%input: S is a hyperrectangle, param is the traffic model parameter, type is the type of nonlinearity
%output: out is a scalar
%description: evaluate the objective function using a point on the middle
%bound of S
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

%Dimension of hyperrectangle S
dim = length(S.h.dim);

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