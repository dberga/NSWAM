function createfigure_fig2_3_Rossi_Paradiso(Y1)  % Figure 2, exp 3 Rossi Paradiso
%CREATEFIGURE1(Y1)
%  Y1:  vector of y data

%  Auto-generated by MATLAB on 21-Sep-2012 15:42:18

% Create figure
figure1 = figure('XVisual',...
    '0x27 (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)');

% Create axes
axes1 = axes('Parent',figure1,...
    'XTickLabel',{'0.5','1','1.5','2','2.5','3','3.5','4'},...
    'FontName','Arial');
% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[1 400]);
box(axes1,'on');
hold(axes1,'all');

% Create xlabel
xlabel('Time (s)','FontSize',12,'FontName','Arial');

% Create ylabel
ylabel('Response','FontSize',12,'FontName','Arial');

% Create plot
plot(Y1,'MarkerFaceColor',[0 0 0],'LineWidth',1,'Color',[0 0 0]);

