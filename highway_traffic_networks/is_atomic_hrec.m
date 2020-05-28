function y = is_atomic_hrec(S,epsilon)
%input: S is a hypeprrectangle struct, epsilon is the tolerance
%output: boolean, true if S is atomic
%description: check whether S is atomic relative to epsilon
%description: S is atomic when all intervals in S are less than or equal to
%epsilon
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

%Dimension of hyperrectangle S
dim = length(S.h.dim);

%Check each dimension
for i = 1:dim
    if is_atomic_inv([S.h.dim(i).l S.h.dim(i).u],epsilon) 
        y = true;
    else
        y = false;
        break;
    end
end

end