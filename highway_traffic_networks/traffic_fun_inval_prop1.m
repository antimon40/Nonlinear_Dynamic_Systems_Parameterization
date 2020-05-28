function out = traffic_fun_inval_prop1(X,param,E_N,sys)
%interval functions for entire function
%this returns the objective value evaluations (square of the norm of gradient vector)
%input: X is a cell of intervals, param is the traffic model parameter, E_N is the
%number of segment in the middle
%Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

sum = [0 0];

%Initialize counter
ctr_onramp = 1;
ctr_offramp = 1;

%Compute
for i = 1:size(sys.A,1)
    if i <= length(sys.E_N)
        if i == 1 % class a (upstream segment)
            sum = inv_add(sum,inv_pow(X{i},2));
        elseif (sys.E_N(i) <= sys.E_I(end)) && (sys.E_N(i) == sys.E_I(ctr_onramp)) % class b (mainline segment connected to onramp)
            Z1 = inv_pow(X{i},2);
            Z2 = inv_pow(X{i-1},2);
            Z3 = inv_pow(X{length(sys.E_N)+ctr_onramp},2);
            sum = inv_add(sum,inv_add(Z1,inv_add(Z2,Z3)));
            ctr_onramp = ctr_onramp + 1;
        elseif (sys.E_N(i) <= sys.E_O(end)) && (sys.E_N(i) == sys.E_O(ctr_offramp)) % class d (mainline segment connected to offramp)
            Z1 = inv_pow(X{i},2);
            Z2 = inv_pow(X{i-1},2);
            Z3 = inv_mul_c(inv_pow(X{length(sys.E_N)+length(sys.E_I)+ctr_offramp},2),(param.alpha_j)^2); 
            sum = inv_add(sum,inv_add(Z1,inv_add(Z2,Z3)));
            ctr_offramp = ctr_offramp + 1;
        else % class c (mainline segment not connected to any ramp)
            sum = inv_add(sum,inv_add(inv_pow(X{i},2),inv_pow(X{i-1},2)));
        end
    elseif (i > length(sys.E_N)) && (i <= length(sys.E_N)+length(sys.E_I)) %Onramps segments
        sum = inv_add(sum,inv_pow(X{i},2)); % class a (onramp segment)
    else %Offramps segments
        sum = inv_add(sum,inv_mul_c(inv_pow(X{i},2),(param.alpha_j)^2)); % class e (offramp segment)
    end
end

%Final result
out = inv_mul_c(sum,4*(param.a)^2);

% for i = 3:E_N-2
%    Z1 = inv_pow(X{i},2);
%    Z2 = inv_pow(X{i-1},2);
%    sum = inv_add(sum,inv_add(Z1,Z2));
% end
% 
% Z = {};
% 
% Z{1} = inv_pow(X{1},2);
% Z{2} = inv_pow(X{1},2);
% Z{3} = inv_pow(X{2},2);
% Z{4} = inv_pow(X{(E_N+1)},2);
% Z{5} = inv_pow(X{E_N-2},2);
% Z{6} = inv_pow(X{E_N-1},2);
% Z{7} = inv_mul_c(inv_pow(X{E_N+2},2),(param.alpha_j)^2); 
% Z{8} = inv_pow(X{E_N-1},2);
% Z{9} = inv_pow(X{E_N},2);
% Z{10} = inv_pow(X{E_N+1},2);
% Z{11} = inv_mul_c(inv_pow(X{E_N+2},2),(param.alpha_j)^2); 
% Z{12} = sum;
% 
% out = [0 0];
% 
% for i = 1:length(Z)
%     out = inv_add(out,Z{i});
% end
% 
% out = inv_mul_c(out,4*(param.a)^2);

end