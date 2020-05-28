%Main Program
%QIB constant computation using interval optimization: lower bound
%Use value from the left corner of S to update L (Moa)
%System: a moving object
%Author: Sebastian A. Nugroho
%Date: 2/26/2019

clear 
close all

%Set algorithm precision
eps_X = 10^-8;
eps_F = [5*10^-4 10^-4 5*10^-5 10^-5 5*10^-6 10^-6 5*10^-7 10^-7 5*10^-8 10^-8];
% eps_F = [10^-6];

%Experiment number
exp_num = eps_F;

%Define set
r = 5;
x_max = [r r];
x_min = [-r -r];

%Is maximization (for upper bound) or minimization (lower bound)
isMax = 0;

%Experiment Data
for i = 1:length(exp_num)
    exp_data1.result{i} = {[]};
end

%Initialize data
data1_tab = cell(length(exp_num),11);

%Experiment 1
for i = 1:length(exp_num)
    
    %Total time
    totalTime = 0;

    %f1
    %Define domain X
    Xset.dim(1).l = x_min(1); %x1
    Xset.dim(1).u = x_max(1);
    Xset.dim(2).l = x_min(2); %x2
    Xset.dim(2).u = x_max(2);
    
    %Set type
    type = 1;

    tic
    %Compute the maximum of the squared norm of gradient vector for each
    result{1} = fun_inval_maximization(Xset,type,2,eps_F(i),eps_X,isMax);
    totalTime = totalTime + toc;

    %f2
    %Define domain X
    Xset.dim(1).l = x_min(1); %x1
    Xset.dim(1).u = x_max(1);
    Xset.dim(2).l = x_min(2); %x2
    Xset.dim(2).u = x_max(2);
    
    %Set type
    type = 2;

    tic
    %Compute the maximum of the squared norm of gradient vector for each
    result{2} = fun_inval_maximization(Xset,type,2,eps_F(i),eps_X,isMax);
    totalTime = totalTime + toc;

    %Compute the one-sided Lipschitz constant
    LipSumSqr = min(-result{1}{1},-result{2}{1}); 
    
    %Compute total split
    total_split = result{1}{4} + result{2}{4}; 
    
    %Compute total time
    totalTime = result{1}{5} + result{2}{5}; 
       
    %Compute total subset
    total_subset = result{1}{6} + result{2}{6}; 
    
    %Compute gap
    gap = mean([result{1}{7} result{2}{7}]); 
    
    %Optimality
    isOpt = result{1}{8} && result{2}{8};
    
    %Compute total split 1 
    total_split1 = result{1}{9} + result{2}{9};
              
    %Compute total split 2
    total_split2 = result{1}{10} + result{2}{10};

    %Approximated Lipschitz constant
    disp(' ');
    fprintf('The lower bound for QIB constant is: %.10f\n',LipSumSqr);
    disp(' ');
    fprintf('The overall computation time: %.3f\n',totalTime);
    
    %Store data    
    data1_tab(i,:) = {i eps_F(i) eps_X LipSumSqr totalTime total_split total_split1 total_split2 total_subset gap isOpt};

    %Convert to table
    Tab1 = cell2table(data1_tab,'VariableNames',{'index','eps_F', 'eps_X', 'gamma','comp_time','total_split','total_split1','total_split2','total_subset','gap','is_optimal'});

    %Save file
    filename = 'data_experiment_table_QIB_lb_F.mat';
    save(filename,'Tab1');
    
    %Save data
    exp_data1.result{i} = {i, eps_F(i), eps_X, LipSumSqr, totalTime, result};
    save('data_experiment_QIB_lb_F.mat','exp_data1'); 
end