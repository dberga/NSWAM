function createfigure_SBC2(cdata1, cdata2, YMatrix1, YMatrix2)
%CREATEFIGURE(CDATA1,CDATA2,YMATRIX1,YMATRIX2)
%  CDATA1:  image cdata
%  CDATA2:  image cdata
%  YMATRIX1:  matrix of y data
%  YMATRIX2:  matrix of y data

%  Auto-generated by MATLAB on 08-Oct-2012 15:10:45

% Create figure
figure1 = figure('XVisual',...
    '0x27 (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)');

% Create subplot
subplot1 = subplot(2,2,1,'Visible','off','Parent',figure1,'YDir','reverse',...
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

% Create subplot
subplot2 = subplot(2,2,3,'Visible','off','Parent',figure1,'YDir','reverse',...
    'TickDir','out',...
    'Layer','top',...
    'DataAspectRatio',[1 1 1]);
% Uncomment the following line to preserve the X-limits of the axes
% xlim(subplot2,[0.5 256.5]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(subplot2,[0.5 256.5]);
box(subplot2,'on');
hold(subplot2,'all');

% Create image
image(cdata2,'Parent',subplot2);

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.489466592151017 0.583837209302326 0.280481594377481 0.341162790697674]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[-30 275]);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(YMatrix1,'Parent',axes1);
set(plot1(1),'LineStyle','--','Color',[0 0 1]);
set(plot1(2),'Color',[1 0 0]);

% Create xlabel
xlabel('# image column','FontName','Arial');

% Create ylabel
ylabel('Brightness (arbitrary units)','FontName','Arial');

% Create title
title('Predicted brightness','FontWeight','bold','FontSize',12,...
    'FontName','Arial');

% Create axes
axes2 = axes('Parent',figure1,...
    'Position',[0.489466592151017 0.11 0.283590402667636 0.341162790697674]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes2,[-30 275]);
box(axes2,'on');
hold(axes2,'all');

% Create multiple lines using matrix input to plot
plot2 = plot(YMatrix2,'Parent',axes2);
set(plot2(1),'LineStyle','--','Color',[0 0 1],...
    'DisplayName','Visual stimulus');
set(plot2(2),'Color',[1 0 0],'DisplayName','Predicted brightness');

% Create xlabel
xlabel('# image column','FontName','Arial');

% Create ylabel
ylabel('Brightness (arbitrary units)','FontName','Arial');

% Create legend
legend1 = legend(axes2,'show');
set(legend1,...
    'Position',[0.807028267137847 0.822211636463318 0.166750587445452 0.0565647482014389],...
    'FontName','Arial');

