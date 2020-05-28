function out = fun_inval_maximization(Xset,param,type,dim,eps_F,eps_X,fun_mode,max_iter_lb,sys)
%Main function for global maximization using interval arithmetic - for
%traffic networks
%Interval arithmetic for global optimization
%Computing the range of Lipschitz constant for differentiable function
%Use value from the left corner of S to update L (Moa)
%input: Xset is the domain set of f, param is the parameters for the traffic density dynamic model, 
%type is the type of f, dim is the number of dimension of f (the number of
%variables in the argument of f),
%eps_F is the epsilon for objective function, eps_X is epsilon for the
%domain set, fun_mode is the mode between corollary 1 or proposition 1
%output: out contains the upper bound, lower bound, and the cover containing the optimal solution 
%Author: Sebastian A. Nugroho
%Date: 5/16/2020

%Define structure for interval in reals
v  = struct; %v is a struct for interval in reals
v.l = {[]}; 
v.u = {[]}; 

%Define structure for hyperrectangle in reals of dimension n
n = dim;
H  = struct; %H is a struct for n dimensonal hyperrectangle
for i = 1:n
    H.dim(i) = v;
end

%Define primitive structure for cover
P = struct; %P is a struct containing: a hyperrectangle set, its lower bound, and its upper bound
P.h = H; 
P.lb = {[]};
P.ub = {[]};

%Define structure for cover
C = struct; %C is a struct for cover
C.dat = struct; %Contains the primitive in the struct of P

%Define domain X
X = H;
for i = 1:dim
    X.dim(i).l = Xset.dim(i).l;
    X.dim(i).u = Xset.dim(i).u;
end

%Define the number of slicing for each interval
q = 2;

%Initialize S
%Compute lb and ub for f(X)
Y = traffic_fun_inval_wrapper(X,param,type,q,fun_mode,sys);
S = P;
S.h = X;
S.lb = Y(1);
S.ub = Y(2);

%Initialize cover
Cov = C;
Cov.dat = {S};

%Initialize L and S_hi
L = scalar_initialize_lower_bound(S,param,type,fun_mode,sys)
% L = S.lb; %Which is always equal to 0 as Lipschitz constant >= 0
S_hi = S; 

%Total split
total_split1 = 0;
total_split2 = 0;

disp('Start global optimization using interval arithmetic');
disp('Calculating . . . . .');

ttt = tic;
%First loop
%Minimize upper bound on f*
iter_ctr_1 = 1;
while ((S_hi.ub-L) > eps_F) && ~is_atomic_hrec(S_hi,eps_X)
    %Procedure P(Cov,S_hi,L)
    %Remove S_hi from Cov
    [Cov,S] = remove_S_from_Cov(Cov,'ub',L,C,eps_X); 
    %Check
    if isequaln(S_hi,S) %compare the two struct
        S_hi = S;
        %Slice S_hi
        [S_L,S_R] = slice_S(S_hi,q,param,type,fun_mode,sys);
        total_split1 = total_split1 + 1;
        %Add S_L and S_R to Cov
        [Cov] = add_S1_S2_to_Cov(Cov,S_L,S_R);
        %Find S with biggest lower bound from Cov
        S_low = find_S_biggest_lb_ub_in_Cov(Cov,'lb');
        %Update L
        L = max(L,scalar_eval_left_bound(S_low,param,type,fun_mode,sys));
        %Remove all S in Cov with upper bound less than L
        [Cov,S_last_removed] = remove_S_from_Cov(Cov,'L',L,C,eps_X);
        
        %Update S_hi
        S_hi = find_S_biggest_lb_ub_in_Cov(Cov,'ub');
    end
    
    %Update counter
    iter_ctr_1 = iter_ctr_1 + 1;
end

%Find S with biggest lower bound from Cov
S_low = find_S_biggest_lb_ub_in_Cov(Cov,'lb');

%Second loop
%Maximize lower bound on f*
iter_ctr_2 = 1;
while ((S_hi.ub-L) > eps_F) && ~is_atomic_Cov(Cov,eps_X) && (iter_ctr_2 <= max_iter_lb)
    %Procedure P(Cov,S_hi,L)
    %Remove S_low from Cov
    [Cov,S] = remove_S_from_Cov(Cov,'lb',L,C,eps_X);
    %Check
    if true %isequaln(S_low,S) %compare the two struct
        S_low = S;
        %Slice S_low
        [S_L,S_R] = slice_S(S_low,q,param,type,fun_mode,sys);
        total_split2 = total_split2 + 1;
        %Add S_L and S_R to Cov
        [Cov] = add_S1_S2_to_Cov(Cov,S_L,S_R);
        %Find S with biggest lower bound from Cov
        S_low = find_S_biggest_lb_ub_in_Cov(Cov,'lb');
        %Update L
        L = max(L,scalar_eval_left_bound(S_low,param,type,fun_mode,sys));
        %Remove all S in Cov with upper bound less than L
        [Cov,S_last_removed] = remove_S_from_Cov(Cov,'L',L,C,eps_X);
        
        %Update S_hi
        S_hi = find_S_biggest_lb_ub_in_Cov(Cov,'ub');
        
        %Update S_low
        S_low = find_S_biggest_lb_ub_in_Cov(Cov,'lb');
    end
    
    %Update counter
    iter_ctr_2 = iter_ctr_2 + 1;
end

%Find better interval for f*
iter_ctr_3 = 1;
iter_ctr_4 = 1;
%Version 2
%Traverse Cov
if  ((S_hi.ub-L) > eps_F) && (length(Cov.dat) > 1) && (~isempty(Cov.dat{1}))
    %Number of element in cover
    n_el = length(Cov.dat);
    curr_idx = 1;
    while curr_idx <= n_el
        %Traverse Cov for S with upper bound smaller than L
        if ~isempty(Cov.dat{curr_idx})
            %Update L
            L = max(L,scalar_eval_left_bound(Cov.dat{curr_idx},param,type,fun_mode,sys));
            %Remove S in Cov with upper bound smaller than L
            for i = 1:n_el
                if (~isempty(Cov.dat{i})) && (Cov.dat{i}.ub < L)
                    %Remove S from Cov
                    Cov.dat{i} = [];
                end
            end
            %Temp Cov
            Temp_Cov = Cov;
            %Clean Temp_Cov
            Temp_Cov = clean_up_Cov(Temp_Cov,C);
            %Update S_hi
            S_hi = find_S_biggest_lb_ub_in_Cov(Temp_Cov,'ub');
            %Update counter
            iter_ctr_3 = iter_ctr_3 + 1;
            %Check stopping condition
            if (S_hi.ub-L) <= eps_F
                break;
            end
        end
        %Update index
        curr_idx = curr_idx + 1;
        %Update counter
        iter_ctr_4 = iter_ctr_4 + 1;
    end
    %Clean Temp_Cov
    Cov = clean_up_Cov(Cov,C);
end

disp('Done!');
compTime = toc(ttt);
fprintf('Computation time: %.3f seconds\n',compTime);
fprintf('Total iterations: %d\n',iter_ctr_1+iter_ctr_2+iter_ctr_3);

% Display the best interval for f*
disp('Best interval');
fprintf('Lower bound on h*: %.10f\n',L);
fprintf('Upper bound on h*: %.10f\n',S_hi.ub);

total_split = total_split1 + total_split2;
gap = S_hi.ub - L;

if gap <= eps_F
    isOptimal = true;
else
    isOptimal = false;
end

%Output vector
out = {S_hi.ub,L,Cov,total_split,compTime,length(Cov.dat),total_split1,total_split2,gap,isOptimal};

end



