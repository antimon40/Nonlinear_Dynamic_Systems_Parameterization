function [lipsqr,timelapse] = function_lipschitz_computation_fmincon(Drx,Dru,param,type)
%Function for Lipschitz constants computation with fmincon 
%Author: Sebastian A. Nugroho
%Date: 5/17/2020

%Set option for fmincon
options = optimoptions('fmincon','Display','iter-detailed');

%Combine and stack ranges
Dr = [Drx; Dru];

%Initial state for fmincon - global search
x0 = (Dr(:,2)-Dr(:,1))/2 + Dr(:,1); %Take middle point

%Global search
gs = GlobalSearch;

%Problem search
problem = createOptimProblem('fmincon','x0',x0,...
    'objective',@fx,'lb',Dr(:,1)','ub',Dr(:,2)');

tt = tic;
%Start computing with globalsearch - fmincon
x_minimizer = run(gs,problem);
timelapse = toc(tt);

%Compute optimal value
lipsqr = -fx(x_minimizer);

function [x_out] = fx(x_in)
    x_out = -generator_fun(x_in,param,type);
end

end