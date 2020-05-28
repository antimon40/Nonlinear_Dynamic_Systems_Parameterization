function [S_L,S_R] = slice_S(S,q,param,type)
%input: S is a hyperrectangle to be sliced
%input: q is the number of slicing for each interval to evaluate F(S)
%output: S_L and S_R 
%description: slice S into S_L and S_R
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

%Dimension of hyperrectangle S
dim = length(S.h.dim);

%Find the maximum width of dimension to be sliced
w_max = -Inf;
ctr_pos = 0;
%Traverse all dimension of S 
for i = 1:dim
    if w_max < inv_width([S.h.dim(i).l S.h.dim(i).u])
        w_max = inv_width([S.h.dim(i).l S.h.dim(i).u]);
        ctr_pos = i;
    end
end

%Midpoint
m = inv_center([S.h.dim(ctr_pos).l S.h.dim(ctr_pos).u]);

%Create S_L
S_L = S;
S_L.h.dim(ctr_pos).l = S.h.dim(ctr_pos).l;
S_L.h.dim(ctr_pos).u = m;
Y = generator_fun_inval_wrapper(S_L.h,param,type,q);
%Compute its lower bound
S_L.lb = Y(1);
%Compute its upper bound
S_L.ub = Y(2);

%Create S_R
S_R = S;
S_R.h.dim(ctr_pos).l = m;
S_R.h.dim(ctr_pos).u = S.h.dim(ctr_pos).u; 
Y = generator_fun_inval_wrapper(S_R.h,param,type,q);
%Compute its lower bound
S_R.lb = Y(1);
%Compute its upper bound
S_R.ub = Y(2);

end