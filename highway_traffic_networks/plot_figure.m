%Plot figure

clear all
close all

%Load file
filename = num2str('database_table_corollary1.mat');
load(filename);

%Convert to matrix
tab_mat = table2cell(Tab_data(:,1:end-1));
tab_mat_cor = cell2mat(tab_mat);
N_cor = tab_mat_cor(:,1);
time_cor = tab_mat_cor(:,6);
Lip_con_cor = tab_mat_cor(:,4);
Lip_con_cor_lb = tab_mat_cor(:,5);

%Load file
filename = num2str('database_table_theorem1.mat');
load(filename);

%Convert to matrix
tab_mat = table2cell(Tab_data(:,1:end-1));
tab_mat_pro = cell2mat(tab_mat);
N_pro = tab_mat_pro(:,1);
time_pro = tab_mat_pro(:,6);
Lip_con_pro = tab_mat_pro(:,4);
Lip_con_pro_lb = tab_mat_pro(:,5);

%Load file
filename = num2str('database_table_1_globalsearch_theorem1.mat');
load(filename);

%Convert to matrix
tab_mat = table2cell(Tab_data(:,:));
tab_mat_gl_pro = cell2mat(tab_mat);
time_gl_pro = tab_mat_gl_pro(:,3);
Lip_gl_pro = tab_mat_gl_pro(:,2);

%Load file
filename = num2str('database_table_1_globalsearch_corollary1.mat');
load(filename);

%Convert to matrix
tab_mat = table2cell(Tab_data(:,:));
tab_mat_gl_cor = cell2mat(tab_mat);
time_gl_cor = tab_mat_gl_cor(:,3);
Lip_gl_cor = tab_mat_gl_cor(:,2);

%Load file
filename = num2str('database_table_1_LDS_corollary1.mat');
load(filename);

%Convert to matrix
tab_mat = table2cell(Tab_data(:,:));
tab_mat_lds_cor = cell2mat(tab_mat);
Lip_lds_cor_sobol = tab_mat_lds_cor(:,3);
Lip_lds_cor_halton = tab_mat_lds_cor(:,4);
time_lds_cor_sobol = tab_mat_lds_cor(:,6);
time_lds_cor_halton = tab_mat_lds_cor(:,7);

%Load file
filename = num2str('database_table_1_LDS_theorem1.mat');
load(filename);

%Convert to matrix
tab_mat = table2cell(Tab_data(:,:));
tab_mat_lds_pro = cell2mat(tab_mat);
Lip_lds_pro_sobol = tab_mat_lds_pro(:,3);
Lip_lds_pro_halton = tab_mat_lds_pro(:,4);
time_lds_pro_sobol = tab_mat_lds_pro(:,6);
time_lds_pro_halton = tab_mat_lds_pro(:,7);

%Plot trajectory
h(1) = figure;
fs = 18;
set(gcf,'numbertitle','off','name','Traffic Networks')
% Create axes
axes1 = axes;
hold on
p1 = plot(N_cor,time_cor,'MarkerFaceColor',[1 1 1],...
    'Marker','square',...%'Color',[0 0 1],...
    'MarkerEdgeColor',[0 0 0],'LineWidth',2.5);
p2 = plot(N_cor,time_pro,'MarkerFaceColor',[1 1 1],...
    'Marker','diamond',...%'Color',[1 0 0],...
    'MarkerEdgeColor',[0 0 0],'LineStyle','-.','LineWidth',2.5);
grid on
box on
xlabel('$M$ ($\#$ of segments)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$\Delta t$ (seconds)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
% set(gca, 'YScale', 'log')
Lgd = legend(gca,[p2 p1],{'Case 1','Case 2'},'location','southeast','interpreter','latex','FontName','Times New Roman','FontSize',18);
% Lgd.FontSize = 18;
% Lgd.Interpreter ='Latex';
% Lgd.Location ='best';
% legend(gca,[p1a p1b p2a p2b p3a p3b],{'$x_2$','$\hat{x}_2$','$x_5$','$\hat{x}_5$','$x_{7}$','$\hat{x}_{7}$'},...
%     'location','northeast','interpreter','latex','FontName','Times New Roman','FontSize',fs);
xlim([N_cor(1) N_cor(end)]);
ylim([min(min(time_cor,time_pro)) max(max(time_cor,time_pro))]);
set(gcf,'color','w');
set(gca,'fontsize',18);

% axes2 = axes('Position',[0.3 0.575 0.37 0.32]);
axes2 = axes('Position',[0.27 0.72 0.43 0.19]);
box on
hold on
p3 = plot(N_cor,time_cor,'MarkerFaceColor',[1 1 1],...
    'Marker','square',...'Color',[0 0 1],...
    'MarkerEdgeColor',[0 0 0],'LineWidth',2.5);
xlim([N_cor(1) N_cor(end)]);
ylim([min(time_cor) max(time_cor)]);

% Lgd = legend('Mosek','SDPNAL+');
% Lgd.FontSize = 15;
% Lgd.Interpreter ='Latex';
% Lgd.Location ='bestoutside';
% legend boxoff   

xlabel('$M$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs-2);
ylabel('$\Delta t$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs-2);

set(gcf,'color','w');
set(gca,'fontsize',14);

set(h(1), 'Position', [700 300 600 400])
print(h(1), 'lip_traffic_comp_time.eps', '-depsc2','-r600')
saveas(h(1),'lip_traffic_comp_time.png')

%Plot figures
h(2) = figure;
fs = 10.5;
set(gcf,'numbertitle','off','name','N vs total time')
%Real plot
subplot(2,1,1);
hold on
box on
grid on
set(gcf,'color','w');
p1 = plot(N_pro,time_pro,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 1],...
    'Marker','s',...
    'LineWidth',1.75,...
    'Color',[0 0 1]);
p2 = plot(N_pro,time_gl_pro,'MarkerFaceColor',[0.87058824300766 0.490196079015732 0],...
    'MarkerEdgeColor',[0.87058824300766 0.490196079015732 0],...
    'Marker','diamond',...
    'LineWidth',1.75,...
    'Color',[0.87058824300766 0.490196079015732 0]);
p3 = plot(N_pro,time_lds_pro_sobol,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0],...
    'Marker','o',...
    'LineWidth',1.75,...
    'Color',[1 0 0]);
p4 = plot(N_pro,time_lds_pro_halton,'MarkerFaceColor',[0.600000023841858 0.200000002980232 0],...
    'MarkerEdgeColor',[0.600000023841858 0.200000002980232 0],...
    'Marker','^',...
    'LineWidth',1.75,...
    'Color',[0.600000023841858 0.200000002980232 0]);
%Dummy plot
hp(1) = plot(N_pro,time_pro,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 1],...
    'Marker','s','LineWidth',1.5,'Color','none');
hp(2) = plot(N_pro,time_gl_pro,'MarkerFaceColor',[0.87058824300766 0.490196079015732 0],...
    'MarkerEdgeColor',[0.87058824300766 0.490196079015732 0],...
    'Marker','diamond','LineWidth',1.5,'Color','none');
hp(3) = plot(N_pro,time_lds_pro_sobol,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0],...
    'Marker','o','LineWidth',1.5,'Color','none');
hp(4) = plot(N_pro,time_lds_pro_halton,'MarkerFaceColor',[0.600000023841858 0.200000002980232 0],...
    'MarkerEdgeColor',[0.600000023841858 0.200000002980232 0],...
    'Marker','^','LineWidth',1.5,'Color','none');
L(1) = plot(nan, nan, 'k','LineWidth',1.5);
L(2) = plot(nan, nan, 'k--','LineWidth',1.5);
% xlabel('$r$ (error)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$\Delta t$ (seconds)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
set(gca, 'YScale', 'log')
xlim([min(N_pro) max(N_pro)]);
ylim([min([min(time_lds_pro_halton) min(time_lds_pro_sobol)]) 50+max([max(time_pro) max(time_gl_pro)])]);
yticks([0 10^0 10^1 10^2])
% ylim([0 10]);
leg1 = legend(hp,'IA','GS','Sobol','Halton');
% % set(leg1,'Interpreter','latex');
set(leg1,'FontSize',fs-2);
set(leg1,'Orientation','horizontal');
leg1.ItemTokenSize(1) = 10;
rect = [0.327, 0.49, .0001, .0001];
set(leg1, 'Position', rect);
legend boxoff;
set(gca,'fontsize',fs);
subplot(2,1,2);
hold on
box on
grid on
set(gcf,'color','w');
%Dummy plot
L(1) = plot(nan, nan, 'k','LineWidth',1.5);
L(2) = plot(nan, nan, 'k--','LineWidth',1.5);
p5 = plot(N_pro,time_cor,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 1],...
    'Marker','s',...
    'LineWidth',1.75,'LineStyle','--',...
    'Color',[0 0 1]);
p6 = plot(N_pro,time_gl_cor,'MarkerFaceColor',[0.87058824300766 0.490196079015732 0],...
    'MarkerEdgeColor',[0.87058824300766 0.490196079015732 0],...
    'Marker','diamond',...
    'LineWidth',1.75,'LineStyle','--',...
    'Color',[0.87058824300766 0.490196079015732 0]);
p7 = plot(N_pro,time_lds_cor_sobol,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0],...
    'Marker','o',...
    'LineWidth',1.75,'LineStyle','--',...
    'Color',[1 0 0]);
p8 = plot(N_pro,time_lds_cor_halton,'MarkerFaceColor',[0.600000023841858 0.200000002980232 0],...
    'MarkerEdgeColor',[0.600000023841858 0.200000002980232 0],...
    'Marker','^',...
    'LineWidth',1.75,'LineStyle','--',...
    'Color',[0.600000023841858 0.200000002980232 0]);
xlabel('$n$ (\# of segments)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$\Delta t$ (seconds)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
set(gca, 'YScale', 'log')
xlim([min(N_pro) max(N_pro)]);
ylim([0 max([max(time_cor) max(time_gl_cor)+2])]); %[min([0 min(time_lds_cor_halton) min(time_lds_cor_sobol) min(time_cor)])
yticks([10^-1 10^0 10^1])
% ylim([0 6]);
leg2 = legend(L,'Case 1','Case 2');
set(leg2,'FontSize',fs-2);
set(leg2,'Orientation','horizontal');
leg2.ItemTokenSize(1) = 15;
rect = [0.76, 0.49, .0001, .0001];
set(leg2, 'Position', rect);
legend boxoff;
set(gca,'fontsize',fs);
set(h(2), 'Position', [600 300 450 400])
print(h(2), 'highway_time.eps', '-depsc2','-r600')
saveas(h(2),'highway_time.png')

%Plot figures
h(3) = figure;
fs = 12.5;
set(gcf,'numbertitle','off','name','N vs total time')
%Real plot
subplot(2,1,1);
hold on
box on
grid on
set(gcf,'color','w');
p2 = plot(N_pro,Lip_gl_pro,'MarkerFaceColor',[0.87058824300766 0.490196079015732 0],...
    'MarkerEdgeColor',[0.87058824300766 0.490196079015732 0],...
    'Marker','diamond',...
    'LineWidth',1.75,...
    'Color',[0.87058824300766 0.490196079015732 0]);
p1 = plot(N_pro,Lip_con_pro,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 1],...
    'Marker','s',...
    'LineWidth',1.75,...
    'Color',[0 0 1]);
p3 = plot(N_pro,Lip_lds_pro_sobol,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0],...
    'Marker','o',...
    'LineWidth',1.75,...
    'Color',[1 0 0]);
p4 = plot(N_pro,Lip_lds_pro_halton,'MarkerFaceColor',[0.600000023841858 0.200000002980232 0],...
    'MarkerEdgeColor',[0.600000023841858 0.200000002980232 0],...
    'Marker','^',...
    'LineWidth',1.75,...
    'Color',[0.600000023841858 0.200000002980232 0]);
%Dummy plot
hp(2) = plot(N_pro,Lip_gl_pro,'MarkerFaceColor',[0.87058824300766 0.490196079015732 0],...
    'MarkerEdgeColor',[0.87058824300766 0.490196079015732 0],...
    'Marker','diamond','LineWidth',1.5,'Color','none');
hp(1) = plot(N_pro,Lip_con_pro,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 1],...
    'Marker','s','LineWidth',1.5,'Color','none');
hp(3) = plot(N_pro,Lip_lds_pro_sobol,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0],...
    'Marker','o','LineWidth',1.5,'Color','none');
hp(4) = plot(N_pro,Lip_lds_pro_halton,'MarkerFaceColor',[0.600000023841858 0.200000002980232 0],...
    'MarkerEdgeColor',[0.600000023841858 0.200000002980232 0],...
    'Marker','^','LineWidth',1.5,'Color','none');
% xlabel('$r$ (error)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$\zeta$ (error)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
% set(gca, 'YScale', 'log')
xlim([min(N_pro) max(N_pro)]);
% ylim([min([min(min(rel_err_det_hwy1))]) max([max(max(rel_err_det_hwy1))])]);
% xticks(sen_cost_det_hwy1_tick);
% yticks([10^-2 10^-1]);
leg1 = legend(hp,'IA','GS','Sobol','Halton');
% % set(leg1,'Interpreter','latex');
set(leg1,'FontSize',fs-3);
set(leg1,'Orientation','horizontal');
leg1.ItemTokenSize(1) = 10;
rect = [0.347, 0.51, .0001, .0001];
set(leg1, 'Position', rect);
legend boxoff;
set(gca,'fontsize',fs);
subplot(2,1,2);
hold on
box on
grid on
set(gcf,'color','w');
%Dummy plot
L(1) = plot(nan, nan, 'k','LineWidth',1.5);
L(2) = plot(nan, nan, 'k--','LineWidth',1.5);
p5 = plot(N_pro,Lip_con_cor,'MarkerFaceColor',[0 0 1],...
    'MarkerEdgeColor',[0 0 1],...
    'Marker','s',...
    'LineWidth',1.75,'LineStyle','--',...
    'Color',[0 0 1]);
p6 = plot(N_pro,Lip_gl_cor,'MarkerFaceColor',[0.87058824300766 0.490196079015732 0],...
    'MarkerEdgeColor',[0.87058824300766 0.490196079015732 0],...
    'Marker','diamond',...
    'LineWidth',1.75,'LineStyle','--',...
    'Color',[0.87058824300766 0.490196079015732 0]);
p7 = plot(N_pro,Lip_lds_cor_sobol,'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0],...
    'Marker','o',...
    'LineWidth',1.75,'LineStyle','--',...
    'Color',[1 0 0]);
p8 = plot(N_pro,Lip_lds_cor_halton,'MarkerFaceColor',[0.600000023841858 0.200000002980232 0],...
    'MarkerEdgeColor',[0.600000023841858 0.200000002980232 0],...
    'Marker','^',...
    'LineWidth',1.75,'LineStyle','--',...
    'Color',[0.600000023841858 0.200000002980232 0]);
xlabel('$r$ (\# of sensors)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$\zeta$ (error)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
% set(gca, 'YScale', 'log')
xlim([min(N_pro) max(N_pro)]);
% ylim([min([min(min(rel_err_trace_hwy1))]) max([max(max(rel_err_trace_hwy1))])]);
% xticks(sen_cost_det_hwy1_tick);
% yticks([10^-2 10^-1]);
leg2 = legend(L,'Case 1','Case 2');
set(leg2,'FontSize',fs-3);
set(leg2,'Orientation','horizontal');
leg2.ItemTokenSize(1) = 20;
rect = [0.78, 0.51, .0001, .0001];
set(leg2, 'Position', rect);
legend boxoff;
set(gca,'fontsize',fs);
set(h(1), 'Position',  [600 300 400 350])
print(h(1), 'highway_lipschitz.eps', '-depsc2','-r600')
saveas(h(1),'highway_lipschitz.png')