function [lipsqr,timelapse] = function_lipschitz_computation_LDS(Drx,Dru,param,type,seq_type,sample_size)
%Function for Lipschitz constants computation with LDS 
%Author: Sebastian A. Nugroho
%Date: 5/17/2020

%Combine and stack ranges
Dr = [Drx; Dru];

tt = tic;
%Start computing with LDS
lipsqr = approximate_lipschitz_2arg(Dr,[],seq_type,sample_size,param,type);
timelapse = toc(tt);

end