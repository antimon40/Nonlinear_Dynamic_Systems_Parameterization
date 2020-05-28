%Main Program
%Lipschitz constant computation using LDS
%Using Proposition 1
%System: traffic density model of stretched highway
%Author: Sebastian A. Nugroho
%Date: 5/16/2020

clear 
close all

%Parameters and constants for highway traffic model, uncongested case
param.rho_m = 0.053; %Maximum density
param.rho_c = param.rho_m/2; %Critical density
param.vf = 31.3; %Free flow speed
param.l = 500; %Length per segment
param.alpha_j = 0.5; %Exit ratio
param.a = param.vf/(param.l*param.rho_m); %delta in the paper

%Define case vector (4s+1)
sections = [5 10 15 20 25 30 35 40 45 50]; %Number of sections
Case_N_V = 4.*sections + 1; %Total segments in the mainline
Case_N_V_total = 4.*sections + 1 + 2.*sections; %Total segments in overall

%Initialize database
database = struct;
for i = 1:length(Case_N_V) %corresponds to the number of experiment
    database.case_N(i).sys = {[]};
    database.case_N(i).random = {[]};
    database.case_N(i).sobol = {[]};
    database.case_N(i).halton = {[]};
    database.case_N(i).N_V = {[]};
end

%Initialize database table
data_table = cell(length(Case_N_V),8);

%Mode: Corrolary 1 ('c') or Theorem 1 ('p')
fun_mode = 'p';

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
    
    %Cast into a simple vector
    param2.q_max = param.rho_c*ones(n,1);
    param2.q_min = [0*ones(n,1)];
    
    %Number of nonlinear function types based on the gradient vector
    %function
    n_f = 1;

    %Dimension of each type of f
    dim_f_v = [n];

    %function type
    obj_ub = zeros(n_f,1);
    obj_lb = zeros(n_f,1);
    
    %Bounds on x
    param2.Dx = [param2.q_min param2.q_max];

    %Bounds on u
    param2.Du = [];

    %Type of nonlinearity
    param2.nonlinear_type = fun_mode; 

    %Number of points
    invalV = [10000];

    %Samples on each interval for random
    sample = 5;
    
    %Function mode
    param2.mode = mode;
    
    %Start computing
    %Sequence type
    seq_type = 'random';

    [vsample_f_r,vmean_f_r] = function_lipschitz_approximation(invalV,...
        sample,seq_type,param2,param,sys,fun_mode,sections(i));

    %Sequence type
    seq_type = 'sobol';

    [vsample_f_s,vmean_f_s] = function_lipschitz_approximation(invalV,...
        1,seq_type,param2,param,sys,fun_mode,sections(i));

    %Sequence type
    seq_type = 'halton';

    [vsample_f_h,vmean_f_h] = function_lipschitz_approximation(invalV,...
        1,seq_type,param2,param,sys,fun_mode,sections(i));    
    
    %Approximated Lipschitz constant
    fprintf('Lipschitz constant for random, sobol, and halton: %.4f %.4f %.4f',vmean_f_r{1},vmean_f_s{1},vmean_f_h{1});
    disp(' ');
       
    %Store data    
    data_table(i,:) = {Case_N_V_total(i) vmean_f_r{1,1} vmean_f_s{1,1} vmean_f_h{1,1} vmean_f_r{1,4} vmean_f_s{1,4} vmean_f_h{1,4} invalV};

    %Convert to table
    Tab_data = cell2table(data_table,'VariableNames',{'total_segments','Lip_con_random','Lip_con_sobol','Lip_con_halton',...
        'Time_random','Time_sobol','Time_halton',...
        'sample_points'});
    
    %Save file
    filename = num2str('database_table_1_LDS_theorem1.mat');
    save(filename,'Tab_data');
    
    %Save matrices to array
    database.case_N(i).sys = {sys};
    database.case_N(i).random = vmean_f_r;
    database.case_N(i).sobol = vmean_f_s;
    database.case_N(i).halton = vmean_f_h;
    database.case_N(i).N_V = {Case_N_V(i)};

    %Save data
    filename = num2str('database_matrix_1_LDS_theorem1.mat');
    save(filename,'database');
end