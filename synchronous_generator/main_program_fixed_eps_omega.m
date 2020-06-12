%Main Program
%Lipschitz constant computation using interval optimization
%Use value from the left corner of S to update L (Moa)
%System: single synchronous generator model
%Author: Sebastian A. Nugroho
%Date: 2/26/2019

clc
clear 
close all

%Load simulation data from PST
filename = strcat('data_simulation_one_generator_fault_gen_16.mat');
load(filename);

%Get generator parameter
param = one_generator_parameter(alpha,beta,x_min,x_max,u_min,u_max);

lipf = analytic_lipschitz(param,'f');

%%%%Experiment 2
%Epsilons for stopping criteria
% eps_F = [16 8 4 2 1 0.5 0.25 0.125]; %epsilon_h
% eps_F = [35 30 25 20 15 10 5 1 0.5 0.1]; %epsilon_h
% eps_F = [60 55 50 45 40 35 30 25 20]; %epsilon_h
eps_F = [80 70 60 50 40 30 20 10]; %epsilon_h
eps_X = 10^-4*ones(1,size(eps_F,2)); %epsilon_omega

%Define the number of slicing for each interval
q = 10;

%Experiment Data
for i = 1:length(eps_X)
    exp_data2.result{i} = {[]};
end

%Initialize data
data1_tab = cell(length(eps_X),12);

%Experiment 1-A
for i = 1:length(eps_F)
    
    %f
    %Define domain X
    Xset.dim(1).l = x_min(1); %x1
    Xset.dim(1).u = x_max(1);
    Xset.dim(2).l = x_min(2); %x2
    Xset.dim(2).u = x_max(2);
    Xset.dim(3).l = x_min(3); %x3
    Xset.dim(3).u = x_max(3);
    Xset.dim(4).l = x_min(4); %x4
    Xset.dim(4).u = x_max(4);
    Xset.dim(5).l = u_min(3); %u1
    Xset.dim(5).u = u_max(3);
    Xset.dim(6).l = u_min(4); %u2
    Xset.dim(6).u = u_max(4);

    %Compute the maximum of the squared norm of gradient vector for each
    result{1} = fun_inval_maximization(Xset,param,[],6,q,eps_F(i),eps_X(i));

    %Compute the Lipschitz constant
    LipSumSqr = result{1}{1}; 
    
    %Compute the Lipschitz constant - lower bound
    LipSumSqr_lb = result{1}{2}; 
    
    %Compute total split
    total_split = result{1}{4}; 
    
    %Compute total time
    totalTime = result{1}{5}; 
       
    %Compute total subset
    total_subset = result{1}{6}; 
    
    %Compute gap
    gap = (result{1}{7}); 
    
    %Optimality
    isOpt = result{1}{8};
    
    %Compute total split 1 
    total_split1 = result{1}{9};
              
    %Compute total split 2
    total_split2 = result{1}{10};

    %Approximated Lipschitz constant
    Lip = sqrt(LipSumSqr);
    disp(' ');
    fprintf('The overall Lipschitz constant is: %.10f\n',Lip);
    disp(' ');
    fprintf('The overall computation time: %.3f\n',totalTime);
    
    %Store data    
    data1_tab(i,:) = {i eps_F(i) eps_X(i) Lip sqrt(LipSumSqr_lb) totalTime total_split total_split1 total_split2 total_subset gap isOpt};

    %Convert to table
    Tab1 = cell2table(data1_tab,'VariableNames',{'index','eps_F','eps_X','lipcon','lipcon_lb','comp_time','total_split','total_split1','total_split2','total_subset','gap','is_optimal'});

    %Save file
    filename = 'data_table_fixed_eps_omega.mat';
    save(filename,'Tab1');
    
    %Save data
    exp_data1.result{i} = {i, eps_F(i), eps_X(i), Lip, totalTime, result, param, lipf};
    save('data_matrix_fixed_eps_omega.mat','exp_data1');
    
end
