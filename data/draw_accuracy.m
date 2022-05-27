clear all

% load data
% Network pruning: 0%, sample selection: 100%
load('CL_without_sampling.mat')
data_1 = accuracy;
% Sample selection: 0%, network pruning: 30%
load('FL_with_pruning.mat')
data_2 = accuracy;
% Sample selection: 100%, network pruning: 0%
load('SemiFL_without_sampling_and_pruning.mat')
data_3 = accuracy;
% Sample selection: 30%, network pruning: 30%
load('SemiFL_with_sampling_and_pruning.mat')
data_4 = accuracy;

% plot figure
figure
plot(data_1,'-o','Linewidth',1.5,'MarkerIndices',[200 400 600 800 1000])
hold on
plot(data_2,'-v','Linewidth',1.5,'MarkerIndices',[200 400 600 800 1000])
plot(data_3,'-*','Linewidth',1.5,'MarkerIndices',[200 400 600 800 1000])
plot(data_4,'-s','Linewidth',1.5,'MarkerIndices',[200 400 600 800 1000])
title('')
xlabel('Communication rounds')
ylabel('Prediction accuracy')
set(gca,'FontName','Times New Roman','FontSize',12);
legend_1 = legend('Baseline 1',...
                  'Baseline 2',...
                  'Baseline 3',...
                  'SemiFL',...
                  'Location','best');
set(legend_1,'FontSize',12);
ylim([0.1 0.9])

% annotation('textarrow',[0.4 0.4],[0.6 0.6],'fontsize',12,...
%            'String','Sample selection: 100%, network pruning: 0%')
% annotation('textarrow',[0.3 0.3],[0.7 0.7],'fontsize',12,...
%            'String','Sample selection: 30%, network pruning: 30%')
% annotation('textarrow',[0.2 0.2],[0.8 0.8],'fontsize',12,...
%            'String','Sample selection: 0%, network pruning: 30%')

