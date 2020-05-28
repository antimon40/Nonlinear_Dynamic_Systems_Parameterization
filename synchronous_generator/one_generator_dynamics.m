function [dx] = one_generator_dynamics(x,u,A,Bu,C,Du,L,n,m,p,param,DeltaT,t,tspan)
% System and observer dynamics of one generator model
% By: Sebastian A. Nugroho
% Date: 9/19/2018

%Separate input vector
x_sys = x(1:n,1);
x_obs = x((n+1):end,1);

%Select vector for u
if t == 0
    i = 1;
else
    for i = 2:size(u,2)
        if (tspan(i-1) <= t) && (t < tspan(i))
            break; 
        end
    end
end

%System
x_nl_sys = fnonlin_one_generator_f(x_sys,u(:,i),param);
dx_sys = A*x_sys + Bu*u(:,i) + x_nl_sys ;
y_sys = fnonlin_one_generator_h(x_sys,u(:,i),param) + Du*u(:,i);

%Observer
x_nl_obs = fnonlin_one_generator_f(x_obs,u(:,i),param);
y_obs = fnonlin_one_generator_h(x_obs,u(:,i),param) + Du*u(:,i);
dx_obs = A*x_obs + Bu*u(:,i) + x_nl_obs + L*(y_sys - y_obs);
%dx_obs = A*x_obs + Bu*u(:,i) + x_nl_obs + L*(C*x_sys - C*x_obs);

%Output vector
dx = [dx_sys; dx_obs];

end