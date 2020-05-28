function [data_all_out,data_mean_out] = function_lipschitz_approximation(invalV,...
    sample,seq_type,param2,param,sys,fun_mode,section)
%Approximation function for Lipschitz constants computation 
%Input: vector of sample points as invalV, 
%       number of repeated experiments for each sample point as sample;
%       certain types of LD sequence as seq_type e.g. 'sobol' or 'halton' or 'random',
%       param is water network's parameter
%Output: vector of sample points as vsample_f,
%        vector of mean values as vmean_f;
%Author: Sebastian A. Nugroho
%Date: 5/17/2020

%Function type
fun_type = param2.mode;

%Initialize table
datatable_all = cell(length(invalV)*sample,6);
datatable_mean = cell(length(invalV),4);

%Table index counter
counter = 1;

%Depend on function type
if isequal(fun_mode,'c')
    %Number of nonlinear function types based on the gradient vector
    %function
    n_f = 5;
    %Dimension of each type of f
    dim_f_v = [1 3 2 3 1];
end

%Get data
if isequal(fun_mode,'p')
    for i = 1:size(invalV,2) %Theorem 1  
        ctr = 1;
        for j = 1:sample
            tt = tic;
            lip = approximate_lipschitz_2arg(param2,param2.Dx,param2.Du,seq_type,invalV(i),param,sys,fun_mode,[]);
            timelapse = toc(tt);

            %Compute mean
            if j == 1
                lipmean = lip;
                timemean = timelapse;
            else
                datmean = cell2mat(datatable_all((i-1)*sample+1:i*sample-1,1));
                lipmean = mean([datmean; lip]);
                timemean = mean([timemean; timelapse]);
            end

            if (j == sample)
                datatable_mean(i,:) = {lipmean invalV(i) seq_type timemean};
            end

            datatable_all(counter,:) = {lip lipmean invalV(i) seq_type timelapse j};

            %Update counter
            counter = counter + 1;
            ctr = ctr + 1;
        end
    end
else
    for i = 1:size(invalV,2) %Corollary 1 
    ctr = 1;
        for j = 1:sample
            liptemp = {};
            tt = tic;
            for k = 1:n_f                
                lip = approximate_lipschitz_2arg(param2,param2.Dx(1:dim_f_v(k),:),param2.Du,seq_type,invalV(i),param,sys,fun_mode,k);                
                liptemp{k} = lip;
            end
            timelapse = toc(tt);
            
            %lipp
            lipp = sqrt((1+section)*liptemp{1} + section*liptemp{2} ...
                + 2*section*liptemp{3} + section*liptemp{4} ...
                + section*liptemp{5});

            %Compute mean
            if j == 1
                lipmean = lipp;
                timemean = timelapse;
            else
                datmean = cell2mat(datatable_all((i-1)*sample+1:i*sample-1,1));
                lipmean = mean([datmean; lipp]);
                timemean = mean([timemean; timelapse]);
            end

            if (j == sample)
                datatable_mean(i,:) = {lipmean invalV(i) seq_type timemean};
            end

            datatable_all(counter,:) = {lipp lipmean invalV(i) seq_type timelapse j};

            %Update counter
            counter = counter + 1;
            ctr = ctr + 1;
        end
    end
end

%Translate to output
data_all_out = datatable_all;
data_mean_out = datatable_mean;

end