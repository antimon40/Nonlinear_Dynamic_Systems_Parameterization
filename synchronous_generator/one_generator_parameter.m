function param = one_generator_parameter(alpha,beta,xmin,xmax,umin,umax)
%Parameters of one generator model
%Author: Sebastian A. Nugroho
%Date: 9/12/2018

if nargin == 0
    %Specify the constant parameters
%     omega_0 = 2*pi*60; %steady state rotor speed (rad/s)
%     K_D_i = 0.05; %damping factor
%     H_i = 2.8765; %inertia constant
%     S_B = 100; %system base (MVA)
%     S_N = 991; %generator base (MVA)
%     Tpo_q = 0.66; %open circuit time constants in q axis
%     Tpo_d = 5; %open circuit time constants in d axis
%     x_q = 1.91; %synchronous reactance in q axis
%     x_d = 2; %synchronous reactance in d axis
%     xp_q = 0.245; %transient reactance in q axis
%     xp_d = 0.245; %transient reactance in d axis
    
    omega_0 = 2*pi*60; %steady state rotor speed (rad/s)
    K_D_i = 0.00; %damping factor
    H_i = 3.4; %inertia constant
    S_B = 100; %system base (MVA)
    S_N = 300; %generator base (MVA)
    Tpo_q = 0.035; %open circuit time constants in q axis
    Tpo_d = 12.6; %open circuit time constants in d axis
    x_q = 0.6; %synchronous reactance in q axis
    x_d = 0.969; %synchronous reactance in d axis
    xp_q = 0.248; %transient reactance in q axis
    xp_d = 0.248; %transient reactance in d axis

    %Wrap the parameters in alpha and beta
    param.a_1 = omega_0;
    param.a_2 = omega_0/(2*H_i);
    param.a_3 = (omega_0/(2*H_i))*(S_B/S_N)^2;
    param.a_4 = (omega_0/(2*H_i))*(S_B/S_N)^3*(xp_q-xp_d);
    param.a_5 = K_D_i/(2*H_i);
    param.a_6 = (K_D_i/(2*H_i))*omega_0;
    param.a_7 = 1/Tpo_d;
    param.a_8 = (1/Tpo_d)*(S_B/S_N)*(x_d-xp_d);
    param.a_9 = 1/Tpo_q;
    param.a_10 = (1/Tpo_q)*(S_B/S_N)*(x_q-xp_q);
    param.b_1 = (1/2)*(S_B/S_N)*(xp_q-xp_d);
    param.b_2 = (1/2)*(S_B/S_N)*(xp_q+xp_d);

%     %Disturbed parameter due to modeling error
%     %Wrap the parameters in alpha and beta
%     param.a_1 = omega_0 + 2;
%     param.a_2 = omega_0/(2*H_i) + rand(1);
%     param.a_3 = (omega_0/(2*H_i))*(S_B/S_N)^2 + rand(1);
%     param.a_4 = (omega_0/(2*H_i))*(S_B/S_N)^3*(xp_q-xp_d) + rand(1);
%     param.a_5 = K_D_i/(2*H_i) + rand(1);
%     param.a_6 = (K_D_i/(2*H_i))*omega_0 + rand(1);
%     param.a_7 = 1/Tpo_d + rand(1);
%     param.a_8 = (1/Tpo_d)*(S_B/S_N)*(x_d-xp_d) + rand(1);
%     param.a_9 = 1/Tpo_q + rand(1);
%     param.a_10 = (1/Tpo_q)*(S_B/S_N)*(x_q-xp_q) + rand(1);
%     param.b_1 = (1/2)*(S_B/S_N)*(xp_q-xp_d);
%     param.b_2 = (1/2)*(S_B/S_N)*(xp_q+xp_d);
    
    %Bounds on the states
    delta = [-1.3844 0.61];%[-pi/2 pi/4]; [-pi/2 pi/2]; %rotor angle (rad)
    omega = [374.17 379.32]; %rotor speed (rad/s)
    ep_q = [1.13 2.01]; %transient voltage in q axis (pu)
    ep_d = [0.11 0.34]; %transient voltage in q axis (pu)
    param.Dx = [delta; omega; ep_q; ep_d];

    %Bounds on the control input
    Tm_i = [0.27 0.29]; %mechanical torque
    Efd = [1.41 2.2]; %internal field voltage (pu)
    iR_i = [2.32 3.0]; %real part of complex current (pu)
    iI_i = [-3.23 0.37]; %imaginary part of complex current (pu)
    param.Du = [Tm_i; Efd; iR_i; iI_i];
    
elseif nargin == 6
    
    % %Wrap the parameters in alpha and beta
    param.a_1 = alpha(1,1) + 0*1*rand(1);
    param.a_2 = alpha(1,2) + 0*1*rand(1);
    param.a_3 = alpha(1,3) + 0*rand(1);
    param.a_4 = alpha(1,4) + 0*rand(1);
    param.a_5 = alpha(1,5) + 0*rand(1);
    param.a_6 = alpha(1,6) + 0*1*rand(1);
    param.a_7 = alpha(1,7) + 0*rand(1);
    param.a_8 = alpha(1,8) + 0*rand(1);
    param.a_9 = alpha(1,9) + 0*rand(1);
    param.a_10 = alpha(1,10) + 0*rand(1);
    param.b_1 = beta(1,1);
    param.b_2 = beta(1,2);
    
    %Bounds on the states
    param.Dx = [xmin' xmax'];

    %Bounds on the control input
    param.Du = [umin' umax'];
end



end