%Simple test function 2
%X is an hyperrectangle
%For each interval, it is divided into q subintervals
%This yields better interval evaluation
%Y is an interval

function Y = f3_inv_2(X,q)
    %Get interval
    X1 = [X.dim(1).l X.dim(1).u];
    X2 = [X.dim(2).l X.dim(2).u];
    X3 = [X.dim(3).l X.dim(3).u];
    X4 = [X.dim(4).l X.dim(4).u];
    
    %Compute interval width
    w_X1 = inv_width(X1);
    w_X2 = inv_width(X2);
    w_X3 = inv_width(X3);
    w_X4 = inv_width(X4);
    
    %Increment of interval
    incr1 = w_X1/q;
    incr2 = w_X2/q;
    incr3 = w_X3/q;
    incr4 = w_X4/q;
    
    %Initialize result
    Y_M = [];
    
    %Initialize output
    Y(1) = Inf;
    Y(2) = -Inf;
    %Create vector of intervals
    for i = 1:q+1
        if i == 1
            X1_v = [X.dim(1).l];
            X2_v = [X.dim(2).l];
            X3_v = [X.dim(3).l];
            X4_v = [X.dim(4).l];
        else
            X1_v = [X1_v X1_v(end)+incr1];
            X2_v = [X2_v X2_v(end)+incr2];
            X3_v = [X3_v X3_v(end)+incr3];
            X4_v = [X4_v X4_v(end)+incr4];
            X_all = {[X1_v(i-1) X1_v(i)],[X2_v(i-1) X2_v(i)],[X3_v(i-1) X3_v(i)],[X4_v(i-1) X4_v(i)]};
            Y_M = [Y_M; f3_inv(X_all)];
            %Compute union
            if size(Y_M,1) >= 1
                 Y(1) = min(Y(1),Y_M(end,1));
                 Y(2) = max(Y(2),Y_M(end,2));
            end
        end
    end
%     %Compute union
%     Y(1) = min(Y_M(:,1));
%     Y(2) = max(Y_M(:,2));
%   Round up to 5 decimal points
Y(1) = round(Y(1),10);
Y(2) = round(Y(2),10);
end