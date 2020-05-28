% Dynamic model of traffic network using LWR model with Greenshields flux function
% E_N: the set of stretched highway
% E_I: the set of on-ramps
% E_O: the set of off-ramps
% S_N: sensors on the stretched highway
% S_I: sensors on the on-ramps
% S_O: sensors on the off-ramps
% SpR: splitting ration of off-ramps
% mode: congested or uncongested
% By: Sebastian A. Nugroho
% Date: 8/26/2018

function [sys] = dynamic_model(E_N, E_I, E_O, S_N, S_I, S_O, SpR, mode, epsilon0)

    %Compute vector length
    N = length(E_N);
    N_I = length(E_I);
    N_O = length(E_O);
    E_IO = [];
    SpR_IO = [];
    %The set of highway sections having BOTH on-ramps and off-ramps
    for i = 1:N_I
        for j = 1:N_O
           if  E_I(i) == E_O(j)
               E_IO = [E_IO E_I(i)];
               SpR_IO = [SpR_IO SpR(j)];
               break;
           end
        end
    end
    N_IO = length(E_IO);
    E_I_not_IO = [];
    counter = 1;
    %The set of highway sections having on-ramps ONLY
    for i = 1:N_I
        if counter <= N_IO
            for j = counter:N_IO
                if E_IO(j) == E_I(i)
                    counter = counter + 1;
                    break;
                else
                   E_I_not_IO = [E_I_not_IO E_I(i)];
                end
            end
        else
            E_I_not_IO = [E_I_not_IO E_I(i)];
        end
    end
    N_I_not_IO = length(E_I_not_IO);
    E_O_not_IO = [];
    SpR_O_not_IO = [];
    counter = 1;
    %The set of highway sections having off-ramps ONLY
    for i = 1:N_O
        if counter <= N_IO
            for j = counter:N_IO
                if E_IO(j) == E_O(i)
                    counter = counter + 1;
                    break;
                else
                   E_O_not_IO = [E_O_not_IO E_O(i)];
                   SpR_O_not_IO = [SpR_O_not_IO SpR(i)];
                end
            end
        else
            E_O_not_IO = [E_O_not_IO E_O(i)];
            SpR_O_not_IO = [SpR_O_not_IO SpR(i)];
        end
    end
    N_O_not_IO = length(E_O_not_IO);
    %The set of highway sections having no on-ramps NOR off-ramps
    E_temp = E_O;
    N_temp = N_O;
    E_not_I_or_O = [];
    for i = 1:N_I
        for j = 1:N_temp
            if E_I(i) == E_temp(j)
                E_temp(j) = [];
                N_temp = N_temp - 1;
                break;
            end  
        end
    end
    E_temp = sort([E_I E_temp],'ascend');
    N_temp = length(E_temp);
    for i = 1:N
        counter = 0;
        for j = 1:N_temp
            if E_N(i) == E_temp(j)
                break;
            else
                counter = counter + 1;
            end  
        end
        if counter == N_temp
            E_not_I_or_O = [E_not_I_or_O E_N(i)];
        end
    end
    N_not_I_or_O = length(E_not_I_or_O);
    
    sN = length(S_N);
    sN_I = length(S_I);
    sN_O = length(S_O);
    
    %Create set of on-ramps and off-ramps
    E_IR = 1:N_I;
    E_OR = 1:N_O;
    
    %initialization
    sys.A = [];
    sys.Bu = zeros(N+N_I+N_O,1+N_I+N_O);
    sys.C = zeros(sN+sN_I+sN_O,N+N_I+N_O);
    sys.lip = 0; %Lipschitz constant
    A1 = [];
    A2 = zeros(N,N_I+N_O);
    A3 = zeros(N_I+N_O,N_I+N_O);
    
    %Get traffic network parameters
    [param] = traffic_network_parameters();

    %Define a
    a = param.vf/param.l;

    if (isequal(mode,'uncongested'))
        %Linear model
        %A1
        A1 = diag(-a*ones(1,N));

        if N > 1
            for i = 2:N
                A1(i,i-1) = a;
            end
        end
    elseif (isequal(mode,'congested'))
        %Linear model
        %A1
        A1 = diag(a*ones(1,N));

        if N > 1
            for i = 1:(N-1)
                A1(i,i+1) = -a;
            end
        end
    end
        
    %A2
    for i = 1:N_I
        A2(E_I(i),E_IR(i)) = a;
    end
    for i = 1:N_O
        A2(E_O(i),N_I+E_OR(i)) = -a*SpR(i);
    end

    %A3
    for i = 1:N_I
        A3(E_IR(i),E_IR(i)) = -a;
    end
    for i = 1:N_O
        A3(N_I+E_OR(i),N_I+E_OR(i)) = a*SpR(i);
    end

    %A
    sys.A = [A1 A2; zeros(N_I+N_O,N) A3];

    %Bu
    if (isequal(mode,'uncongested'))
        sys.Bu(1,1) = 1/param.l;
        for i = 1:N_I
            sys.Bu(N+E_IR(i),1+E_IR(i)) = 1/param.l;
        end
        for i = 1:N_O
            sys.Bu(N+N_I+E_OR(i),1+N_I+E_OR(i)) = -1/param.l;
        end
    elseif (isequal(mode,'congested'))
        sys.Bu(N,1) = -1/param.l;
        for i = 1:N_I
            sys.Bu(N+E_IR(i),1+E_IR(i)) = 1/param.l;
        end
        for i = 1:N_O
            sys.Bu(N+N_I+E_OR(i),1+N_I+E_OR(i)) = -1/param.l;
        end
    end

    %C
    for i = 1:sN
        sys.C(i,S_N(i)) = 1;
    end
    for i = 1:sN_I
        sys.C(sN+i,N+S_I(i)) = 1;
    end
    for i = 1:sN_O
        sys.C(sN+sN_I+i,N+N_I+S_O(i)) = 1;
    end

    %Lipschitz constant
    %E_O\(E_I and E_O)
    sum_1 = 0;
    for i = 1:N_O_not_IO
        sum_1 = sum_1 + 2*sqrt(2)*SpR_O_not_IO(i) + SpR_O_not_IO(i)^2;
    end
    %E_I and E_O
    sum_2 = 0;
    for i = 1:N_IO
        sum_2 = sum_2 + 4*SpR_IO(i) + SpR_IO(i)^2;
    end
    %E_O
    sum_3 = 0;
    for i = 1:N_O
        sum_3 = sum_3 + SpR(i)^2;
    end
    if (isequal(mode,'uncongested'))
        sys.lip = a*sqrt(2*N+3*N_I-1+sum_1+sum_2+sum_3);
    elseif (isequal(mode,'congested'))
        sys.lip = 2*a*sqrt(2*N+3*N_I-1+sum_1+sum_2+sum_3);
    end
    
    %Bounds on the Jacobian
    gamma_l = zeros(N+N_I+N_O,N+N_I+N_O);
    gamma_u = zeros(N+N_I+N_O,N+N_I+N_O);
    if (isequal(mode,'uncongested'))
        for i = 1:N + N_I + N_O
            for j =1:N + N_I + N_O
                if i == 1
                    if j == 1
                        gamma_l(i,j) = 0; gamma_u(i,j) = a;
                    else
                        gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                    end
                elseif ((i > 1) && (i <= N))
                    if j <= N
                        if j == i-1
                            gamma_l(i,j) = -a; gamma_u(i,j) = 0;
                        elseif j == i
                            gamma_l(i,j) = 0; gamma_u(i,j) = a;
                        else
                            gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                        end
                    elseif ((j > N) && (j <= N + N_I))
                        if abs(sys.A(i,j)) > 0
                            gamma_l(i,j) = -a; gamma_u(i,j) = 0;
                        else
                            gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                        end
                    elseif j > N + N_I
                        if abs(sys.A(i,j)) > 0
                            gamma_l(i,j) = 0; gamma_u(i,j) = a*SpR(j-N-N_I);
                        else
                            gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                        end
                    end
                elseif ((i > N) && (i <= N + N_I))  
                    if j == i
                        gamma_l(i,j) = 0; gamma_u(i,j) = a;
                    else
                        gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                    end
                elseif i > N + N_I
                    if j == i
                        gamma_l(i,j) = -a*SpR(j-N-N_I); gamma_u(i,j) = 0;
                    else
                        gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                    end
                end
            end
        end
     elseif (isequal(mode,'congested'))
        for i = 1:N + N_I + N_O
            for j =1:N + N_I + N_O
                if i == N
                    if j == N
                        gamma_l(i,j) = -2*a; gamma_u(i,j) = -a + epsilon0;
                    else
                        gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                    end
                elseif ((i >= 1) && (i < N))
                    if j <= N
                        if j == i+1
                            gamma_l(i,j) = a + epsilon0; gamma_u(i,j) = 2*a;
                        elseif j == i
                            gamma_l(i,j) = -2*a; gamma_u(i,j) = -a + epsilon0;
                        else
                            gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                        end
                    elseif ((j > N) && (j <= N + N_I))
                        if abs(sys.A(i,j)) > 0
                            gamma_l(i,j) = -2*a; gamma_u(i,j) = -a + epsilon0;
                        else
                            gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                        end
                    elseif j > N + N_I
                        if abs(sys.A(i,j)) > 0
                            gamma_l(i,j) = a*SpR(j-N-N_I) + epsilon0; gamma_u(i,j) = 2*a*SpR(j-N-N_I);
                        else
                            gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                        end
                    end
                elseif ((i > N) && (i <= N + N_I))   
                    if j == i
                        gamma_l(i,j) = a + epsilon0; gamma_u(i,j) = 2*a;
                    else
                        gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                    end
                elseif i > N + N_I
                    if j == i
                        gamma_l(i,j) = -2*a*SpR(j-N-N_I); gamma_u(i,j) = -a*SpR(j-N-N_I) + epsilon0;
                    else
                        gamma_l(i,j) = 0; gamma_u(i,j) = 0;
                    end
                end
            end
        end
    end
    
%     %Check observability
%     disp('Check observability');
%     Ob = obsv(sys.A,sys.C);
%     if (rank(Ob) == size(sys.A,1))
%         disp('System is observable');
%     else
%         disp('System is not observable');
%         rank(Ob)
%     end
%     
%     %Check detectability
%     disp('Check detectability');

    %Dummy variable
    noOfUnstableMode = 0;
    isDetec = 0;

    %Eigenvalues of A
    eigA = eig(sys.A);
    
    %PBH test
    for i = 1:size(eigA,1)   
        if real(eigA(i)) >= 0
           %Update numbers
           noOfUnstableMode = noOfUnstableMode + 1;

           %PBH test for detectability
           if rank([sys.A-eigA(i)*eye(size(sys.A,1)); sys.C]) == size(sys.A,1)
               isDetec = isDetec + 1;
           end
        end
    end

%     %Result
%     if noOfUnstableMode == isDetec
%         disp('System is detectable');
% %         out.isDetectable = 1;
%     else
%         disp('System is not detectable');
% %         out.isDetectable = 0;
%     end

    %Combine all variables
    sys.n = size(sys.A,1);
    sys.m = size(sys.Bu,2);
    sys.p = size(sys.C,1);
    sys.N = N;
    sys.N_I = N_I;
    sys.N_O = N_O;
    sys.N_IO = N_IO;
    sys.N_I_not_IO = N_I_not_IO;
    sys.N_O_not_IO = N_O_not_IO;
    sys.N_not_I_or_O = N_not_I_or_O;
    sys.E_N = E_N; 
    sys.E_I = E_I; 
    sys.E_O = E_O; 
    sys.E_IO = E_IO;
    sys.E_I_not_IO = E_I_not_IO;
    sys.E_O_not_IO = E_O_not_IO;
    sys.E_not_I_or_O = E_not_I_or_O;
    sys.S_N = S_N; 
    sys.S_I = S_I; 
    sys.S_O = S_O; 
    sys.SpR = SpR; 
    sys.SpR_IO = SpR_IO;
    sys.SpR_O_not_IO = SpR_O_not_IO;
    sys.mode = mode;
    sys.gamma_u = gamma_u;
    sys.gamma_l = gamma_l;
    sys.param = param;
    
end