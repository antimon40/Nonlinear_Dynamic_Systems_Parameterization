function Y = traffic_fun_inval_wrapper(X,param,type,q,fun_mode,sys)
%scalar functions for each type of nonlinearity
%this returns the objective values (square of the norm of gradient vector)
%input: X is a cell of intervals, param is the traffic model parameter,
%type is the type index for each nonlinearity, q is the number of subintervals of X
%For each interval in X, it is divided into q subintervals
%This yields better interval evaluation
%output: Y is an interval
%Author: Sebastian A. Nugroho
%Date: 2/25/2019

%Dimension of hyperrectangle X
dim = length(X.dim);

%Get interval
X_lu = zeros(dim,2);
for i = 1:dim
    X_lu(i,:) = [X.dim(i).l X.dim(i).u];
end

%Compute interval width
w_X_lu = zeros(dim,1);
for i = 1:dim
    w_X_lu(i,1) = inv_width(X_lu(i,:));
end

%Increment of interval
X_incr = zeros(dim,1);
for i = 1:dim
    X_incr(i,1) = w_X_lu(i,1)/q;
end

%Initialize result
Y_M = [];

%Initialize output
Y(1) = Inf;
Y(2) = -Inf;

%Create vector of intervals
X_v = [];
for i = 1:q+1
    if i == 1
        for j = 1:dim
            X_v = [X_v; X.dim(j).l];
        end
    else
        X_v_temp = [];
        for j = 1:dim
            X_v_temp = [X_v_temp; X_v(j,end)+X_incr(j,1)];
        end
        X_v = [X_v X_v_temp];
        X_all = {};
        for j = 1:dim
            X_all{j} = [X_v(j,i-1) X_v(j,i)];
        end
        if isequal(fun_mode,'c') == 1
            %Interval evaluation
            Y_M = [Y_M; traffic_fun_inval(X_all,param,type)];
        else
            %Interval evaluation
            Y_M = [Y_M; traffic_fun_inval_prop1(X_all,param,param.E_N,sys)];
        end
        %Compute union hull
        if size(Y_M,1) >= 1
             Y(1) = min(Y(1),Y_M(end,1));
             Y(2) = max(Y(2),Y_M(end,2));
        end
    end
end
%Round up to 10 decimal points
Y(1) = round(Y(1),10);
Y(2) = round(Y(2),10);
end