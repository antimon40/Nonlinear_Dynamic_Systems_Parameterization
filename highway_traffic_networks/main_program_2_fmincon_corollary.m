%Main Program
%Lipschitz constant computation using fmincon
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
    database.case_N(i).result = {[]};
    database.case_N(i).N_V = {[]};
end

%Initialize database table
data_table = cell(length(Case_N_V),3);

%Mode: Corrolary 1 ('c') or Theorem 1 ('p')
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
    
    %Cast into a simple vector
    q_max = param.rho_c*ones(n,1);
    q_min = [0*ones(n,1)];
    
    %Bounds on x
    Dx = [q_min q_max];

    %Bounds on u
    Du = [];
    
    %Sample
    sample = 1;
    
    %Start computing with global search
    [data_all_out,data_mean_out] = function_lipschitz_computation_fmincon(Dx,Du,sample,param,sys,fun_mode,sections(i));
    
    %Approximated Lipschitz constant
    fprintf('Lipschitz constant: %.10f\n',data_mean_out{1,1});
    disp(' ');

    %Store data    
    data_table(i,:) = {Case_N_V_total(i) data_mean_out{1,1} data_mean_out{1,2}};

    %Convert to table
    Tab_data = cell2table(data_table,'VariableNames',{'total_segments','Lip_con_mean',...
        'Time_total_mean'});
    
    %Save file
    filename = num2str('database_table_1_globalsearch_corollary1.mat');
    save(filename,'Tab_data');
    
    %Save matrices to array
    database.case_N(i).sys = {sys};
    database.case_N(i).result = {data_mean_out};
    database.case_N(i).N_V = {Case_N_V(i)};

    %Save data
    filename = num2str('database_matrix_1_globalsearch_corollary1.mat');
    save(filename,'database');
end