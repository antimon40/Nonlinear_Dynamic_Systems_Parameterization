% Function to generate system matrices
% Observer design for nonlinear system by Zhang et. al.
% Author: Sebastian A. Nugroho
% Date: 6/7/2017

function [sys] = system_matrix()

%System matrix
sys.A = [1 -1 ;1 1];

%Input vector
sys.Bu = [0;0];

%Disturbance vector
sys.Bw = [1;0];

%Output vector  
sys.C = [0 1];  

%Attack vector
sys.Dw = 1;

%Nonlinearity in the system and observer
sys.Bf = eye(2);
sys.Phi = {'-x(1)*(x(1)^2+x(2)^2)';...
    '-x(2)*(x(1)^2+x(2)^2)'};
sys.Phihat = {'-xhat(1)*(xhat(1)^2+xhat(2)^2)';...
    '-xhat(2)*(xhat(1)^2+xhat(2)^2)'};

%Set constants
% osl = 0;
% lip = 640;
% lb = -24;
% ub = osl;
osl = 0;
lip = 25000;
lb = -150;
ub = osl;

%Multipliers (nonnegative)
eps1 = 10^5;
eps2 = 1*10^-1;

%Lipschitz constants
sys.lipc.delta = eps1*ub-eps2*lb+lip; %Lipschitz (gamma_1)
sys.lipc.phi = eps2-eps1; %gamma_2
sys.lipc.rho = 0; %OSL

%Dimension
sys.dim.nx = size(sys.A, 1);        % number of states
sys.dim.nu = size(sys.Bu, 2);       % number of control inputs
sys.dim.nw = size(sys.Bw, 2);       % number of disturbance inputs
sys.dim.ny = size(sys.C, 1);        % number of outputs
sys.dim.nf = size(sys.Bf, 2);       % number of nonlinearities
sys.dim.nd = size(sys.Dw, 2);       % number of attacks

end