function [out] = scalar_initialize_lower_bound(S,type,isMax)
%input: S is a hyperrectangle, param is the traffic model parameter, type is the type of nonlinearity
%output: out is a scalar
%description: initialize lower bound
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
out = moving_object_fun(x,type,isMax);

end