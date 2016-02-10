function createfigure_GI(cdata1, YMatrix1)
%CREATEFIGURE(CDATA1,YMATRIX1)
%  CDATA1:  image cdata
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 08-Oct-2012 16:19:09

% Create figure
figure1 = figure('XVisual',...
    '0x27 (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)');

% Create subplot
subplot1 = subplot(1,2,1,'Visible','off','Parent',figure1,'YDir','reverse',...
    'TickDir','out',...
    'Layer','top',...
    'DataAspectRatio',[1 1 1]);
% Uncomment the following line to preserve the X-limits of the axes
% xlim(subplot1,[0.5 256.5]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(subplot1,[0.5 256.5]);
box(subplot1,'on');
hold(subplot1,'all');

% Create image
image(cdata1,'Parent',subplot1);

% Create title
title('Visual stimulus','FontWeight','bold','FontSize',12,...
    'FontName','Arial');

% Create text
text('Parent',subplot1,'String','A',...
    'Position',[-13.6846965699209 -9.29419525065958 1810.70026516405],...
    'FontWeight','bold',...
    'FontSize',12,...
    'FontName','Arial');

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.485657551211675 0.11 0.291220210202169 0.815]);
% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[1 255]);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(YMatrix1,'Parent',axes1,'Color',[0 0 0]);
set(plot1(1),'LineStyle','--','DisplayName','Visual stimulus');
set(plot1(2),'DisplayName','Upper and lower sinusoidal stripes');
set(plot1(3),'Color',[1 0 0],'DisplayName','Predicted brightness');

% Create xlabel
xlabel('# image column','FontName','Arial');

% Create ylabel
ylabel('Brightness (arbitrary units)','FontName','Arial');

% Create title
title('Predicted brightness','FontWeight','bold','FontSize',12,...
    'FontName','Arial');

% Create text
text('Parent',axes1,'String','B',...
    'Position',[-25.686075949367 258.905013192612 17.3205080756888],...
    'FontWeight','bold',...
    'FontSize',12,...
    'FontName','Arial');

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.791247340860743 0.795041816009558 0.180105547373589 0.122371565113501],...
    'FontName','Arial');
