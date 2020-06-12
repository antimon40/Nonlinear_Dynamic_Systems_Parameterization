function [data_all_out,data_mean_out] = function_lipschitz_computation_fmincon_jacobian(Dx,Du,sample,param,sys,fcnHandleJacobian,section)
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

%Counter
ctr = 1;
for j = 1:sample 

    %Initial state for fmincon - global search
    a = Dx(:,1);
    b = Dx(:,2);
    x0 = (b-a)/2; %Take middle point
%     x0 = a;

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
    lip = -lipsqr;

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

%Translate to output
data_all_out = datatable_all;
data_mean_out = datatable_mean;

function [x_out] = fx(x_in)
    x_out = -norm(fcnHandleJacobian(x_in),2);
end

end