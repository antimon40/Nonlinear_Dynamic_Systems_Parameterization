function y = is_atomic_inv(X,epsilon)
%input: X is an interval on real, where X = [x_l x_u]
%output: boolean
%description: check whether X is atomic relative to epsilon
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

if inv_width(X) <= epsilon
    y = true;
else
    y = false;
end

end