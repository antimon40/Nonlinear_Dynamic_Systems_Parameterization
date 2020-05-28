function lipf = approximate_lipschitz_2arg(Dx,Du,lds,sample_size,param,type)
%Approximate the (locally) Lipschitz constant using low-discrepancy (LD) sequence
%Input: nonlinear function f(x,u) as fnonlin, 
%       nonlinear function constants and parameters as param;
%       bounds on x as Dx = [x1_lo x1_hi; x2_lo x2_hi; ...], 
%       bounds on u as Du = [u1_lo u1_hi; u2_lo u2_hi; ...], 
%       certain types of LD sequence as lds e.g. 'sobol' or 'halton' or 'random',
%       number of points to be computed as sample_size
%Output: approximation of lipschitz constant as lip
%Author: Sebastian A. Nugroho
%Date: 5/17/2020

%Check input
if nargin ~= 6
    warning('Function takes 6 arguments. Try again.');
    return;
end

%Number of states 
Nx = size(Dx,1);

%Number of inputs
Nu = size(Du,1);

%Create LD sequence of points
if isequal(lds,'sobol')
%     %Randomize skip
%     skipn = randi([1 1000],1,1);
    %Randomize leap
%     leapn = randi([1 100],1,1);
    %Create Sobol sequence 
    Px = sobolset(Nx);
%     Pu = sobolset(Nu);
elseif isequal(lds,'halton')
%     %Randomize skip
%     skipn = randi([1 1000],1,1);
    %Randomize leap
    leapn = randi([1 100],1,1);
    %Create Halton sequence 
    Px = haltonset(Nx);
%     Pu = haltonset(Nu);
elseif isequal(lds,'random')
    Pxr = rand(1*sample_size,Nx);
%     Pur = rand(1*sample_size,Nu);
end

%Initialize maximum norm of Jacobian
lip = -Inf;

%Nonlinear function
fx = @generator_fun;
   
%Scale the random points to each domain
if ~isequal(lds,'random')
    %Take the first sample_size points from the LD sequence
    Qx = net(Px,1*sample_size);
%     Qu = net(Pu,1*sample_size);

    %Scale Qx to the region Dx
    Q2x = zeros(size(Qx));
    for i = 1:Nx
        Q2x(:,i) = rescale(Qx(:,i),Dx(i,1),Dx(i,2));
    end

%     %Scale Qu to the region Du
%     Q2u = zeros(size(Qu));
%     for i = 1:Nu
%         Q2u(:,i) = Qu(:,i)*abs(Du(i,1)-Du(i,2))+Du(i,1);
%     end
else
    %Scale Qx to the region Dx
    Q2x = zeros(size(Pxr));
    for i = 1:Nx
        Q2x(:,i) = rescale(Pxr(:,i),Dx(i,1),Dx(i,2));
    end

%     %Scale Qu to the region Du
%     Q2u = zeros(size(Pur));
%     for i = 1:Nu
%         Q2u(:,i) = Pur(:,i)*abs(Du(i,1)-Du(i,2))+Du(i,1);
%     end
end

%Select all pairs and compute the Lipschitz constant
for i = 1:sample_size 
   lipconcand = fx(Q2x(i,:)',param,type); %(x,param,E_N,sys)
   lip = max(lip,lipconcand);
end
lipf = lip;

end


    