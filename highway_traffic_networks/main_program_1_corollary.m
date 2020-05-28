%Main Program
%Lipschitz constant computation using interval optimization
%Use value from the left corner of S to update L (Moa) using Corollary 1
%System: traffic density model of stretched highway
%Author: Sebastian A. Nugroho
%Date: 8/20/2019

clear
close all

%Parameters and constants for highway traffic model, uncongested case
param.rho_m = 0.053; %Maximum density
param.rho_c = param.rho_m/2;
param.vf = 31.3;
param.l = 500;
param.alpha_j = 0.5;
param.a = param.vf/(param.l*param.rho_m);

%Define case vector (4s+1)
sections = [5 10 15 20 25 30 35 40 45 50]; %Number of sections
Case_N_V = 4.*sections + 1; %Total segments in the mainline
Case_N_V_total = 4.*sections + 1 + 2.*sections; %Total segments in overall

%Epsilons for stopping criteria
eps_F = 10^-4;
eps_X = 10^-7;

%Max iter low bound refinement
max_iter_lb = 10^2;

%Initialize database
database = struct;
for i = 1:length(Case_N_V) %corresponds to the number of experiment
    database.case_N(i).sys = {[]};
    database.case_N(i).lip = {[]};
    database.case_N(i).lip_lb = {[]};
    database.case_N(i).final_ub = {[]};
    database.case_N(i).final_lb = {[]};
    database.case_N(i).comp_time = {[]};
    database.case_N(i).split = {[]};
    database.case_N(i).subset = {[]};
    database.case_N(i).E_N = {[]};
    database.case_N(i).N_V = {[]};
    database.case_N(i).gap = {[]};
    database.case_N(i).status = {[]};
    database.case_N(i).result = {[]};
end

%Initialize database table
data_table = cell(length(Case_N_V),12);

%Mode: Corrolary 1 (c) or Theorem 1 (p)
fun_mode = 'c';

for i = 1:length(Case_N_V)

    %Compute analytical Lipschitz constant
    %Construct the highway structure (must be ordered, no element duplication)
    % E_N: the set of stretched highway
    E_N = 1:Case_N_V(i);
    % E_I: the set of on-ramps
    E_I = 4.*(1:sections(i))-2; %1 on-ramps
    % E_O: the set of off-ramps
    E_O = 4.*(1:sections(i)); %1 off-ramps
    % S_N: sensors on the stretched highway
    S_N = [1 E_N(end)];
    % S_I: sensors on the on-ramps
    S_I = 1:sections(i);
    % S_O: sensors on the off-ramps
    S_O = 1:sections(i);
    %Splitting ratio of off-ramps
    SpR = param.alpha_j*ones(1,sections(i));
    
    %Update param
    param.E_N = length(E_N);

    %Mode
    mode = 'uncongested';

    %Epsilon for Jacobian bounds
    epsilon0 = 10^-9;

    %Obtain the dynamic model
    [sys] = dynamic_model(E_N, E_I, E_O, S_N, S_I, S_O, SpR, mode, epsilon0);

    %Number of states (or number of total segments)
    n = size(sys.A,1);

    %Define domain X
    for j = 1:n
        Xset.dim(j).l = 0;
        Xset.dim(j).u = param.rho_c;
    end
    
    %Number of nonlinear function types based on the gradient vector
    %function
    n_f = 5;

    %Dimension of each type of f
    dim_f_v = [1 3 2 3 1];

    %function type
    obj_ub = zeros(n_f,1);
    obj_lb = zeros(n_f,1);
    
    tic
    %Compute the maximum of the squared norm of gradient vector for each
    for j = 1:n_f
        result{j} = fun_inval_maximization(Xset,param,j,dim_f_v(j),eps_F,eps_X,fun_mode,max_iter_lb,sys);
    end
    totalTime = toc
    
    %Compute the Lipschitz constant
    LipSumSqr = (1+sections(i))*result{1}{1} + sections(i)*result{2}{1} ...
                + 2*sections(i)*result{3}{1} + sections(i)*result{4}{1} ...
                + sections(i)*result{5}{1};
            
    %Compute the Lipschitz constant - lb
    LipSumSqr_lb = (1+sections(i))*result{1}{2} + sections(i)*result{2}{2} ...
                + 2*sections(i)*result{3}{2} + sections(i)*result{4}{2} ...
                + sections(i)*result{5}{2};
            
    %Upper bound
    final_ub = (1+sections(i))*result{1}{1} + sections(i)*result{2}{1} ...
                + 2*sections(i)*result{3}{1} + sections(i)*result{4}{1} ...
                + sections(i)*result{5}{1};
    
    %Lower bound
    final_lb = (1+sections(i))*result{1}{2} + sections(i)*result{2}{2} ...
                + 2*sections(i)*result{3}{2} + sections(i)*result{4}{2} ...
                + sections(i)*result{5}{2};
            
    %Compute total split
    total_split = result{1}{4} + result{2}{4} + result{3}{4} + result{4}{4} ...
                  + result{5}{4};
              
    %Compute total split 1 
    total_split1 = result{1}{7} + result{2}{7} + result{3}{7} + result{4}{7} ...
                  + result{5}{7};
              
    %Compute total split 2
    total_split2 = result{1}{8} + result{2}{8} + result{3}{8} + result{4}{8} ...
                  + result{5}{8};
    
    %Compute total time
    totalTime = result{1}{5} + result{2}{5} + result{3}{5} + result{4}{5} ...
                + result{5}{5};
       
    %Compute total subset
    total_subset = result{1}{6} + result{2}{6} + result{3}{6} + result{4}{6} ...
                   + result{5}{6}; 
               
    %Compute gap
    gap = mean([result{1}{9} result{2}{9} result{3}{9} result{4}{9} result{5}{9}]); 
    
    %Optimality
    isOpt = result{1}{10} && result{2}{10} && result{3}{10} && result{4}{10} && result{5}{10};

    %Approximated Lipschitz constant
    Lip = sqrt(LipSumSqr);
    disp(' ');
    fprintf('The overall Lipschitz constant is: %.10f\n',Lip);
    disp(' ');
    fprintf('The overall computation time: %.3f\n',totalTime);
    
    %Store data    
    data_table(i,:) = {Case_N_V(i) final_lb final_ub Lip sqrt(LipSumSqr_lb) totalTime total_split total_split1 total_split2 total_subset gap isOpt};

    %Convert to table
    Tab_data = cell2table(data_table,'VariableNames',{'total_segments','lb','ub','Lip_con','Lip_con_lb','comp_time','total_split','total_split1','total_split2','total_subset','gap','is_optimal'});
    
    %Save file
    filename = num2str('database_table_corollary1.mat');
    save(filename,'Tab_data');
    
    %Save matrices to array
    []
    database.case_N(i).sys = {sys};
    database.case_N(i).lip = {Lip};
    database.case_N(i).lip_lb = {sqrt(LipSumSqr_lb)};
    database.case_N(i).final_ub = {final_ub};
    database.case_N(i).final_lb = {final_lb};
    database.case_N(i).comp_time = {totalTime};
    database.case_N(i).split = {total_split};
    database.case_N(i).subset = {total_subset};
    database.case_N(i).E_N = {dim_f_v(j)};
    database.case_N(i).N_V = {Case_N_V(i)};
    database.case_N(i).gap = {gap};
    database.case_N(i).status = {isOpt};
    database.case_N(i).result = result;

    %Save data
    filename = num2str('database_matrix_corollary1.mat');
    save(filename,'database');
end


