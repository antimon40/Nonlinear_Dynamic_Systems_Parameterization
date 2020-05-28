function [data_all_out,data_mean_out] = function_lipschitz_computation_fmincon(Dx,Du,sample,param,sys,fun_mode,section)
%Function for Lipschitz constants computation with fmincon 
%Author: Sebastian A. Nugroho
%Date: 5/17/2020

%Initialize table
datatable_all = cell(sample,4);
datatable_mean = cell(2);

%Set option for fmincon
options = optimoptions('fmincon','Display','iter-detailed');

%Table index counter
counter = 1;

%Dummy
i = 1;

%Depend on function type
if isequal(fun_mode,'c')
    %Number of nonlinear function types based on the gradient vector
    %function
    n_f = 5;
    %Dimension of each type of f
    dim_f_v = [1 3 2 3 1];
end

%Get data
if isequal(fun_mode,'p') %Theorem 1
    ctr = 1;
    for j = 1:sample 

        %Initial state for fmincon - global search
        a = Dx(:,1);
        b = Dx(:,2);
        x0 = (b-a)/2; %Take middle point

        %Global search
        gs = GlobalSearch;

        %Problem search
        problem = createOptimProblem('fmincon','x0',x0,...
            'objective',@fx,'lb',Dx(:,1)','ub',Dx(:,2)');

        tt = tic;
        %Start computing with fmincon
        x_minimizer = run(gs,problem);
    %     [x_minimizer,lipsqr] = fmincon(@fx,x0,[],[],[],[],Dx(:,1),Dx(:,2),[],options);
        timelapse = toc(tt);

        %Compute optimal value
        lipsqr = fx(x_minimizer);

        %Lipschitz constant
        lip = sqrt(-(lipsqr));

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
            datatable_mean(i,:) = {lipmean timemean};
        end

        datatable_all(counter,:) = {lip lipmean timelapse j};

        %Update counter
        counter = counter + 1;
        ctr = ctr + 1;
    end
else %Corollary 1
    ctr = 1;
    for j = 1:sample 

        %Global search
        gs = GlobalSearch;
        liptemp = {};
        timelapse = 0;
        for k = 1:n_f 
            %Initial state for fmincon - global search
            a = Dx(1:dim_f_v(k),1);
            b = Dx(1:dim_f_v(k),2);
            x0 = (b-a)/2; %Take middle point

            %Problem search
            problem = createOptimProblem('fmincon','x0',x0,...
                'objective',@fx2,'lb',Dx(1:dim_f_v(k),1)','ub',Dx(1:dim_f_v(k),2)');

            tt = tic;
            %Start computing with fmincon
            x_minimizer = run(gs,problem);
            timelapse = timelapse + toc(tt);

            %Compute optimal value
            lipsqr = traffic_fun(x_minimizer,param,k);

            %Lipschitz constant
            liptemp{k} = (lipsqr);
        end
        
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
            datatable_mean(i,:) = {lipmean timemean};
        end

        datatable_all(counter,:) = {lipp lipmean timelapse j};

        %Update counter
        counter = counter + 1;
        ctr = ctr + 1;
    end
end

%Translate to output
data_all_out = datatable_all;
data_mean_out = datatable_mean;

function [x_out] = fx(x_in)
    x_out = -traffic_fun_prop1(x_in,param,sys.E_N,sys);
end

function [x_out] = fx2(x_in)
    x_out = -traffic_fun(x_in,param,k);
end

end