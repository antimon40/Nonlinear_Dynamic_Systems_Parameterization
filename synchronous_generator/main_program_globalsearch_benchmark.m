%Main Program
%Lipschitz constant computation using interval optimization
%Use value from the left corner of S to update L (Moa)
%System: single synchronous generator model
%Author: Sebastian A. Nugroho
%Date: 2/26/2019

clear 
close all

%Load simulation data from PST
filename = strcat('data_simulation_one_generator_fault_gen_14.mat');
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
data1_tab = cell(length(eps_F),2);

%Experiment 1-A
for i = 1:length(eps_F)
    
    %f2
    %Define domain X 
    Drx(1,:) = [x_min(1) x_max(1)]; %x1
    Drx(2,:) = [x_min(3) x_max(3)]; %x3
    Drx(3,:) = [x_min(4) x_max(4)]; %x4
    Dru(1,:) = [u_min(3) u_max(3)]; %u1
    Dru(2,:) = [u_min(4) u_max(4)]; %u2
    
    %Compute the maximum of the squared norm of gradient vector for type 2
    type = 2;
    [lipsqr1,comptime1] = function_lipschitz_computation_fmincon(Drx,Dru,param,type);

    %f3
    %Define domain X
    Drx(1,:) = [x_min(1) x_max(1)]; %x1
    Dru(1,:) = [u_min(3) u_max(3)]; %u1
    Dru(2,:) = [u_min(4) u_max(4)]; %u2

    %Compute the maximum of the squared norm of gradient vector for type 3
    type = 3;
    [lipsqr2,comptime2] = function_lipschitz_computation_fmincon(Drx,Dru,param,type);

    %f4
    %Define domain X
    Drx(1,:) = [x_min(1) x_max(1)]; %x1
    Dru(1,:) = [u_min(3) u_max(3)]; %u1
    Dru(2,:) = [u_min(4) u_max(4)]; %u2

    %Compute the maximum of the squared norm of gradient vector for type 3
    type = 4;
    [lipsqr3,comptime3] = function_lipschitz_computation_fmincon(Drx,Dru,param,type);

    %Compute the Lipschitz constant
    LipSumSqr = lipsqr1 + lipsqr2 + lipsqr3; 
    
    %Compute total time
    totalTime = comptime1 + comptime2 + comptime3; 

    %Approximated Lipschitz constant
    Lip = sqrt(LipSumSqr);
    disp(' ');
    fprintf('The overall Lipschitz constant is: %.10f\n',Lip);
    disp(' ');
    fprintf('The overall computation time: %.3f\n',totalTime);
    
    %Store data    
    data1_tab(i,:) = {Lip totalTime};

    %Convert to table
    Tab1 = cell2table(data1_tab,'VariableNames',{ 'Lipcon','comp_time'});

    %Save file
    filename = 'data_table_globalsearch_benchmark.mat';
    save(filename,'Tab1');
    
    %Save data
    exp_data1.result{i} = {Lip, totalTime};
    save('data_matrix_globalsearch_benchmark.mat','exp_data1');
    
end
