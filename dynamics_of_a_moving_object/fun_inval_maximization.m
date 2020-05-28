function out = fun_inval_maximization(Xset,type,dim,eps_F,eps_X,isMax)
%Main function for global maximization using interval arithmetic
%Interval arithmetic for global optimization
%Computing the range of Lipschitz constant for differentiable function
%Use value from the left corner of S to update L (Moa)
%input: Xset is the domain set of f, param is the parameters for the traffic density dynamic model, 
%type is the type of f, dim is the number of dimension of f (the number of
%variables in the argument of f),
%eps_F is the epsilon for objective function, eps_X is epsilon for the
%domain set
%output: out contains the upper bound, lower bound, and the cover containing the optimal solution 
%Author: Sebastian A. Nugroho
%Date: 1/31/2019

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
q = 1;

%Initialize S
%Compute lb and ub for f(X)
Y = moving_object_fun_inval_wrapper(X,type,q,isMax);
S = P;
S.h = X;
S.lb = Y(1);
S.ub = Y(2);

%Initialize cover
Cov = C;
Cov.dat = {S};

%Initialize L and S_hi
L = scalar_initialize_lower_bound(S,type,isMax);
% L = S.lb; %Which is always equal to 0 as Lipschitz constant >= 0
S_hi = S; 

%Total split
total_split1 = 0;

disp('Start global optimization using interval arithmetic');
disp('Calculating . . . . .');

tic
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
        [S_L,S_R] = slice_S(S_hi,q,type,isMax);
        total_split1 = total_split1 + 1;
        %Add S_L and S_R to Cov
        [Cov] = add_S1_S2_to_Cov(Cov,S_L,S_R);
        %Find S with biggest lower bound from Cov
        S_low = find_S_biggest_lb_ub_in_Cov(Cov,'lb');
        %Update L
        L = max(L,scalar_eval_left_bound(S_low,type,isMax));
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

total_split2 = 0;

%Second loop
%Maximize lower bound on f*
iter_ctr_2 = 1;
while ((S_hi.ub-L) > eps_F) && ~is_atomic_Cov(Cov,eps_X)
    %Procedure P(Cov,S_hi,L)
    %Remove S_low from Cov
    [Cov,S] = remove_S_from_Cov(Cov,'lb',L,C,eps_X);
    %Check
    if true %isequaln(S_low,S) %compare the two struct
        S_low = S;
        %Slice S_low
        [S_L,S_R] = slice_S(S_low,q,type,isMax);
        total_split2 = total_split2 + 1;
        %Add S_L and S_R to Cov
        [Cov] = add_S1_S2_to_Cov(Cov,S_L,S_R);
        %Find S with biggest lower bound from Cov
        S_low = find_S_biggest_lb_ub_in_Cov(Cov,'lb');
        %Update L
        L = max(L,scalar_eval_left_bound(S_low,type,isMax));
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
            L = max(L,scalar_eval_left_bound(Cov.dat{curr_idx},type,isMax));
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
    %Clean Cov
    Cov = clean_up_Cov(Cov,C);
end

disp('Done!');
compTime = toc;
fprintf('Computation time: %.3f seconds\n',compTime);
fprintf('Total iterations: %d\n',iter_ctr_1+iter_ctr_2+iter_ctr_3);

%Display the best interval for f*
disp('Best interval');
fprintf('Lower bound on f*: %.10f\n',L);
fprintf('Upper bound on f*: %.10f\n',S_hi.ub);

% %Display the union hull of all subsets in the cover
% if (length(Cov.dat) == 1) && isempty(Cov.dat{1})
%         disp('Cover is empty');
% else
%     disp('Showing the union hull for all subsets of x*');
%     n_el = length(Cov.dat);
%     lb_vec = zeros(n,1);
%     ub_vec = zeros(n,1);
%     for i = 1:n
%         lb_vec_temp = inf; 
%         ub_vec_temp = -inf;
%         for j = 1:n_el
%            lb_vec_temp = min(lb_vec_temp,Cov.dat{j}.h.dim(i).l); 
%            ub_vec_temp = max(ub_vec_temp,Cov.dat{j}.h.dim(i).u); 
%         end
%         lb_vec(i,1) = lb_vec_temp;
%         ub_vec(i,1) = ub_vec_temp;
%         fprintf('Lower bound on dimension %d: %.10f\n',i,lb_vec(i,1));
%         fprintf('Upper bound on dimension %d: %.10f\n',i,ub_vec(i,1));
%     end
% end

% %Display the domain in the cover
% if (length(Cov.dat) == 1) && isempty(Cov.dat{1})
%         disp('Cover is empty');
% else
%     disp('Showing the domain of x* for each subset');
%     n_el = length(Cov.dat);
%     for i = 1:n_el
%         fprintf('Hyperrectangle %d\n',i);
%         for j = 1:n
%            fprintf('Lower bound on dimension %d: %.10f\n',j,Cov.dat{i}.h.dim(j).l);
%            fprintf('Upper bound on dimension %d: %.10f\n',j,Cov.dat{i}.h.dim(j).u);
%         end
%     end
% end

%Approximated Lipschitz constant
fprintf('The approximate one-sided Lipschitz constant is: %.10f\n',(S_hi.ub));

total_split = total_split1 + total_split2;

gap = S_hi.ub - L;

if gap <= eps_F
    isOptimal = true;
else
    isOptimal = false;
end

%Output vector
out = {S_hi.ub,L,Cov,total_split,compTime,length(Cov.dat),gap,isOptimal,total_split1,total_split2};

end



