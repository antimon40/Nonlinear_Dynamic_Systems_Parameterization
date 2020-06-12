%Main Program
%Lipschitz constant computation using interval optimization
%Use value from the left corner of S to update L (Moa)
%System: single synchronous generator model
%Author: Sebastian A. Nugroho
%Date: 2/26/2019

clear 
close all

%Load simulation data from PST
filename = strcat('data_simulation_one_generator_fault_gen_16.mat');
load(filename);

%Get generator parameter
param = one_generator_parameter(alpha,beta,x_min,x_max,u_min,u_max);

lipf = analytic_lipschitz(param,'f');

%%%%Experiment 1-A
%Epsilons for stopping criteria
eps_X = 10^-3; %epsilon_omega
eps_F = 10^-2; %epsilon_h

%Experiment Data
for i = 1:length(eps_F)
    exp_data1.result{i} = {[]};
end

%Initialize data
data1_tab = cell(length(eps_F),4);

%Sample size
sample_size = 10000;

%Experiment 1-A
for i = 1:length(eps_F)
    
    %f2
    %Define domain X 
    Drx(1,:) = [x_min(1) x_max(1)]; %x1
    Drx(2,:) = [x_min(2) x_max(2)]; %x2
    Drx(3,:) = [x_min(3) x_max(3)]; %x3
    Drx(4,:) = [x_min(4) x_max(4)]; %x4
    Dru(1,:) = [u_min(3) u_max(3)]; %u1
    Dru(2,:) = [u_min(4) u_max(4)]; %u2
    
%     %Sequence type
%     seq_type = 'random';
%     
%     %Compute the maximum of the squared norm of gradient vector for type 2
%     type = 2;
%     [lipsqr1_r,comptime1_r] = function_lipschitz_computation_LDS(Drx,Dru,param,type,seq_type,sample_size);
    
    %Sequence type
    seq_type = 'sobol';
    
    %Compute the maximum of the squared norm of gradient vector for type 2
    type = [];
    [lipsqr1_s,comptime1_s] = function_lipschitz_computation_LDS(Drx,Dru,param,type,seq_type,sample_size);
    
    %Sequence type
    seq_type = 'halton';
    
    %Compute the maximum of the squared norm of gradient vector for type 2
    type = [];
    [lipsqr1_h,comptime1_h] = function_lipschitz_computation_LDS(Drx,Dru,param,type,seq_type,sample_size);
   
    %Compute the Lipschitz constant - sobol
    LipSumSqr_s = lipsqr1_s; 
    
    %Compute the Lipschitz constant - halton
    LipSumSqr_h = lipsqr1_h; 

%     %Approximated Lipschitz constant
%     Lip_r = sqrt(LipSumSqr_r);
%     disp(' ');
%     fprintf('The overall Lipschitz constant - random: %.10f\n',Lip_r);
%     disp(' ');
%     fprintf('The overall computation time - random: %.3f\n',totalTime_r);
    
    %Approximated Lipschitz constant
    Lip_s = sqrt(LipSumSqr_s);
    disp(' ');
    fprintf('The overall Lipschitz constant - sobol: %.10f\n',Lip_s);
    disp(' ');
    fprintf('The overall computation time - sobol: %.3f\n',comptime1_s);
    
    %Approximated Lipschitz constant
    Lip_h = sqrt(LipSumSqr_h);
    disp(' ');
    fprintf('The overall Lipschitz constant - halton: %.10f\n',Lip_h);
    disp(' ');
    fprintf('The overall computation time - halton: %.3f\n',comptime1_h);
    
    %Store data    
    data1_tab(i,:) = {Lip_s Lip_h comptime1_s comptime1_h};

    %Convert to table
    Tab1 = cell2table(data1_tab,'VariableNames',{ 'Lipcon_sobol','Lipcon_halton','time_sobol','time_halton'});

    %Save file
    filename = 'data_table_LDS_benchmark.mat';
    save(filename,'Tab1');
    
    %Save data
    exp_data1.result{i} = {Lip_s, Lip_h, comptime1_s, comptime1_h};
    save('data_matrix_LDS_benchmark.mat','exp_data1');
    
end
