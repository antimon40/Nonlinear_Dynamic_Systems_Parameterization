%Main Program
%Lipschitz constant computation using interval optimization
%Use value from the left corner of S to update L (Moa)
%System: traffic density model of stretched highway
%Author: Sebastian A. Nugroho
%Date: 2/24/2019

clear all
close all

% %Compute analytical Lipschitz constant
% %Construct the highway structure (must be ordered, no element duplication)
% % E_N: the set of stretched highway
% E_N = 1:100;
% % E_I: the set of on-ramps
% E_I = [2]; %1 on-ramps
% % E_O: the set of off-ramps
% E_O = [99]; %1 off-ramps
% % S_N: sensors on the stretched highway
% S_N = [1 100];
% % S_I: sensors on the on-ramps
% S_I = [1];
% % S_O: sensors on the off-ramps
% S_O = [1];
% %Splitting ratio of off-ramps
% SpR = [0.5];

%Construct the highway structure (must be ordered, no element duplication)
% E_N: the set of stretched highway
E_N = 1:10;
% E_I: the set of on-ramps
E_I = [3 5]; %2 on-ramps
% E_O: the set of off-ramps
E_O = [4 5 7 8]; %3 off-ramps
% S_N: sensors on the stretched highway
S_N = [1 2 3 4 5 6 7 8 9 10];
% S_I: sensors on the on-ramps
S_I = [1 2];
% S_O: sensors on the off-ramps
S_O = [1 2 3 4];
%Splitting ratio of off-ramps
SpR = [0.2 0.3 0.4 0.5];
%SpR = [0 0 0 0];

%Mode
mode = 'uncongested';

%Epsilon for Jacobian bounds
epsilon0 = 10^-9;

%Obtain the dynamic model
[sys] = dynamic_model(E_N, E_I, E_O, S_N, S_I, S_O, SpR, mode, epsilon0);

%Parameters and constants for highway traffic model, uncongested case
param.rho_m = 0.053; %Maximum density
param.rho_c = param.rho_m/2;
param.vf = 31.3;
param.l = 500;
param.alpha_j = 0.5;
param.a = param.vf/(param.l*param.rho_m);

% %Number of states (or number of segments)
% n = 100+2;
% 
% %Number of segments in the middle without ramps
% n_r = n-6;

%Number of states (or number of segments)
n = 10+2+4;

%Number of segments in the middle without ramps
n_r = 4;

%Define domain X
for i = 1:n
    Xset.dim(i).l = 0;
    Xset.dim(i).u = param.rho_c;
end

% %Epsilons for stopping criteria
% eps_F = 10^-8;
% eps_X = 10^-12;

%Number of nonlinear function types
% n_f = 5;

%Number of nonlinear function types
n_f = 6;

%Dimension of each type of f
dim_f_v = [1 3 2 3 1 4];

%function type
obj_ub = zeros(n_f,1);
obj_lb = zeros(n_f,1);

% %Initialize result
% result = {};
% 
% tic
% %Compute the maximum of the squared norm of gradient vector for each
% for i = 1:n_f
%     result{i} = fun_inval_maximization(Xset,param,i,dim_f_v(i),eps_F,eps_X);
% end
% totalTime = toc
% 
% %Compute the Lipschitz constant
% LipSumSqr = result{1}{1} + result{2}{1} + n_r*result{3}{1} + result{4}{1} ...
%             + result{5}{1} + result{6}{1} + result{7}{1};
%         
% %Approximated Lipschitz constant
% Lip = sqrt(LipSumSqr);
% disp(' ');
% fprintf('The overall Lipschitz constant is: %.10f\n',Lip);


% %Epsilons for stopping criteria
% eps_F = [10^-4 10^-5 10^-6 10^-7 10^-8];
% eps_X = [10^-4 10^-5 10^-6 10^-7 10^-8];
% 
% %Experiment Data
% for i = 1:length(eps_F)
%     exp_data1.result{i} = {[]};
% end
% 
% %Initialize data
% data1_tab = cell(length(eps_F),7);
% 
% %Experiment 1
% for i = 1:length(eps_F)
%     
%     tic
%     %Compute the maximum of the squared norm of gradient vector for each
%     for j = 1:n_f
%         result{j} = fun_inval_maximization(Xset,param,j,dim_f_v(j),eps_F(i),eps_X(i));
%     end
%     totalTime = toc
% 
%     %Compute the Lipschitz constant
%     LipSumSqr = result{1}{1} + result{2}{1} + n_r*result{3}{1} + result{4}{1} ...
%                 + result{5}{1} + result{6}{1} + result{7}{1};
% 
%     %Approximated Lipschitz constant
%     Lip = sqrt(LipSumSqr);
%     disp(' ');
%     fprintf('The overall Lipschitz constant is: %.10f\n',Lip);
%     
%     %Store data    
%     data1_tab(i,:) = {i eps_F(i) eps_X Lip totalTime};
% 
%     %Convert to table
%     Tab1 = cell2table(data1_tab,'VariableNames',{'index','eps_F', 'eps_X', 'gamma','comp_time'});
% 
%     %Save file
%     filename = 'data_experiment1tab.mat';
%     save(filename,'Tab1');
%     
%     %Save data
%     exp_data1.result{i} = {i, eps_F(i), eps_X, Lip, totalTime};
%     save('data_experiment1.mat','exp_data1');
%     
% end

%Epsilons for stopping criteria
eps_F = [10^-6 10^-7 10^-8 10^-9 10^-10];
eps_X = [10^-6 10^-7 10^-8 10^-9 10^-10];

%Experiment Data
for i = 1:length(eps_X)
    exp_data2.result{i} = {[]};
end

%Initialize data
data2_tab = cell(length(eps_X),7);

%Experiment 2-A
for i = 1:length(eps_X)
    
    tic
    %Compute the maximum of the squared norm of gradient vector for each
    for j = 1:n_f
        result{j} = fun_inval_maximization(Xset,param,j,dim_f_v(j),eps_F(i),eps_X(i));
    end
    totalTime = toc

%     %Compute the Lipschitz constant
%     LipSumSqr = result{1}{1} + result{2}{1} + n_r*result{3}{1} + result{4}{1} ...
%                 + result{3}{1} + result{1}{1} + result{5}{1};
%             
%     %Compute total split
%     total_split = result{1}{4} + result{2}{4} + result{3}{4} + result{4}{4} ...
%                   + result{5}{4};
%     
%     %Compute total time
%     totalTime = result{1}{5} + result{2}{5} + result{3}{5} + result{4}{5} ...
%                 + result{5}{5};
%        
%     %Compute total subset
%     total_subset = result{1}{6} + result{2}{6} + result{3}{6} + result{4}{6} ...
%                    + result{5}{6}; 

    %Compute the Lipschitz constant
    LipSumSqr = result{1}{1} + result{2}{1} + n_r*result{3}{1} + 3*result{4}{1} ...
                + 2*result{1}{1} + 4*result{5}{1} + result{5}{1};
            
    %Compute total split
    total_split = result{1}{4} + result{2}{4} + result{3}{4} + result{4}{4} ...
                  + result{5}{4} + result{6}{4};
    
    %Compute total time
    totalTime = result{1}{5} + result{2}{5} + result{3}{5} + result{4}{5} ...
                + result{5}{5} + result{6}{5};
       
    %Compute total subset
    total_subset = result{1}{6} + result{2}{6} + result{3}{6} + result{4}{6} ...
                   + result{5}{6} + result{6}{6}; 

    %Approximated Lipschitz constant
    Lip = sqrt(LipSumSqr);
    disp(' ');
    fprintf('The overall Lipschitz constant is: %.10f\n',Lip);
    disp(' ');
    fprintf('The overall computation time: %.3f\n',totalTime);
    
    %Store data    
    data2_tab(i,:) = {i eps_F(i) eps_X(i) Lip totalTime total_split total_subset};

    %Convert to table
    Tab2 = cell2table(data2_tab,'VariableNames',{'index', 'eps_F', 'eps_X','gamma','comp_time','total_split','total_subset'});

    %Save file
    filename = 'data_experiment2tab-case2.mat';
    save(filename,'Tab2');
    
    %Save data
    exp_data2.result{i} = {i, eps_F, eps_X(i), Lip, totalTime, result};
    save('data_experiment2-case2.mat','exp_data2');
    
end









