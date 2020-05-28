function out = traffic_fun_prop1(x,param,E_N,sys)
%scalar functions for entire function
%this returns the objective values (square of the norm of gradient vector)
%input: x is the vector, param is the traffic model parameter, E_N is the
%number of segment in the middle
%Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

sum = 0;

%Initialize counter
ctr_onramp = 1;
ctr_offramp = 1;

%Compute
for i = 1:size(sys.A,1)
    if i <= length(sys.E_N)
        if i == 1 % class a (upstream segment)
            sum = sum + x(i)^2;
        elseif (sys.E_N(i) <= sys.E_I(end)) && (sys.E_N(i) == sys.E_I(ctr_onramp)) % class b (mainline segment connected to onramp)
            sum = sum + x(i)^2 + x(i-1)^2 + x(length(sys.E_N)+ctr_onramp)^2; 
            ctr_onramp = ctr_onramp + 1;
        elseif (sys.E_N(i) <= sys.E_O(end)) && (sys.E_N(i) == sys.E_O(ctr_offramp)) % class d (mainline segment connected to offramp)
            sum = sum + x(i)^2 + x(i-1)^2 + (param.alpha_j)^2*x(length(sys.E_N)+length(sys.E_I)+ctr_offramp)^2; 
            ctr_offramp = ctr_offramp + 1;
        else % class c (mainline segment not connected to any ramp)
            sum = sum + x(i)^2+x(i-1)^2;
        end
    elseif (i > length(sys.E_N)) && (i <= length(sys.E_N)+length(sys.E_I)) %Onramps segments
        sum = sum + x(i)^2; % class a (onramp segment)
    else %Offramps segments
        sum = sum + (param.alpha_j)^2*x(i)^2; % class e (offramp segment)
    end
end

%Final result
out = 4*(param.a)^2*sum;

% for i = 3:E_N-2
%    sum = sum + x(i)^2+x(i-1)^2; 
% end
% 
% out = 4*(param.a)^2*(x(1)^2 + x(1)^2 + x(2)^2 + x(E_N+1)^2 + x(E_N-2)^2 + ...
%         x(E_N-1)^2 + (param.alpha_j)^2*x(E_N+2)^2 + x(E_N-1)^2 + x(E_N)^2 + ...
%         x(E_N+1)^2 + (param.alpha_j)^2*x(E_N+2)^2 + sum);

end