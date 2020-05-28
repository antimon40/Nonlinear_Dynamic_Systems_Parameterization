% Function to simulate the results
% Observer design for nonlinear system by Zhang et. al.
% Author: Sebastian A. Nugroho
% Date: 6/7/2017

function [] = system_simul(sys,L)

%Initial conditions
x0 =  [ 0; 1.2 ];
xhat0 = [ 0.5; -1.5 ];

%Time span
disp(' ');
tspan = 0:0.001:5;

disp(' ');
disp('Solving ODE...')
[t, z] = ode15s(@system_model, tspan, [x0; xhat0], [], sys, L);
disp('Done!')     

x = z(:, 1:sys.dim.nx);
xhat= z(:,sys.dim.nx+1:end);

disp(' ');
disp('Plotting...')
%Plot states
for k=1:sys.dim.nx
    subplot(ceil(sys.dim.nx/2),2,k)
    plot(t, z(:,k), t,xhat(:,k), 'r--','LineWidth',2.5);
    grid on
    grid minor
    fs=16;

    xlabel('Time (s)','FontName','Times New Roman','FontSize',fs);
    ylabel(['$x_',num2str(k),'(t)$'],'interpreter','latex','FontSize',16); 
    set(gca,'FontName','Times New Roman','fontsize',fs);
    h = legend('Actual','Estimated','Location','northeast');
    set(h,'Fontsize',fs)
end


fs=16;
figure;
for k=1:sys.dim.nx
    subplot(ceil(sys.dim.nx/2),2,k)    
    plot(t, z(:,k)-xhat(:,k),'LineWidth',2.5);
    grid on
    grid minor
    xlabel('Time (s)','interpreter','latex','FontSize',fs);
    ylabel(['$x_',num2str(k),'(t)','-\hat{x}_',num2str(k),'(t)$'],...
        'interpreter','latex','FontSize',16); 
    set(gca,'FontName','Times New Roman','fontsize',fs);
end

% Plot Error norm
ts = size(x, 1);
e = zeros(ts, sys.dim.nx);
nor = zeros(ts, 1);
for k=1:ts
    e(k,:) = x(k,:) - xhat(k,:);
    nor(k) = norm(e(k,:));    
end

figure;
plot(t, nor, 'LineWidth',2.5);
grid on
grid minor
xlabel('Time (s)','interpreter','latex','FontSize',fs);
ylabel('$\|x-\hat{x}\|$','interpreter','latex','FontName','Times New Roman','FontSize',fs); 
set(gca,'FontName','Times New Roman','fontsize',fs);

fs = 18;
h(1) = figure;
set(gcf,'numbertitle','off','name','System and Observer Trajectory')
%title('Rotor Angle')
hold on
p1a = plot(t,z(:,1),'LineWidth',2.5);
p1b = plot(t,xhat(:,1),'LineStyle','-.','LineWidth',2.5);
hold off
box on
grid off
xlabel('$t$ (seconds)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$x_1(t), \hat{x}_1(t)$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
legend(gca,[p1a p1b],{'$x_1(t)$','$\hat{x}_1(t)$'},...
    'location','best','interpreter','latex','FontName','Times New Roman','FontSize',fs);
set(gcf,'color','w');
legend boxoff;
set(gca,'fontsize',18);
xlim([t(1) t(end)]);
ylim([min([min(z(:,1)) min(xhat(:,1))]) max([max(z(:,1)) max(xhat(:,1))])])
set(h(1), 'Position', [100 0 500 370])
print(h(1), 'state_1_OSL_QIB.eps', '-depsc2','-r600')

fs = 18;
h(2) = figure;
set(gcf,'numbertitle','off','name','System and Observer Trajectory')
%title('Rotor Angle')
hold on
p1a = plot(t,z(:,2),'LineWidth',2.5);
p1b = plot(t,xhat(:,2),'LineStyle','-.','LineWidth',2.5);
hold off
box on
grid off
xlabel('$t$ (seconds)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$x_2(t), \hat{x}_2(t)$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
legend(gca,[p1a p1b],{'$x_2(t)$','$\hat{x}_2(t)$'},...
    'location','best','interpreter','latex','FontName','Times New Roman','FontSize',fs);
set(gcf,'color','w');
set(gca,'fontsize',18);
xlim([t(1) t(end)]);
set(h(2), 'Position', [100 0 500 370])
print(h(2), 'state_2.eps', '-depsc2','-r600')
end