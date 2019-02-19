function [ map ] = visualize_scanpath2( image, scanpath, scanpath_times, marker_color , printtext)

tpf=50; %if scanpath does not provide time, set default per gaze as 300
if nargin <5, printtext=true; end
if nargin <4, marker_color=[1 0 0;1 0 0; 1 0 0; 1 0 0; 0 0 0 ]; end
if nargin < 3 && size(scanpath,2) > 3
    scanpath_times=scanpath(:,3:4);
else
    f=1:size(scanpath,1);
    scanpath_times=[];
    scanpath_times(:,1)=tpf.*f - tpf;
    scanpath_times(:,2)=tpf.*f;
end

if printtext
fixtime=scanpath_times(:,2)-scanpath_times(:,1);
markersize= round(fixtime*(10/tpf)+10);
else
 markersize(1:size(scanpath,1))= 7;
end
init_markercolor=marker_color(3,:);
markercolor=marker_color(1,:);
markerlinecolor=marker_color(2,:);
markertextcolor=marker_color(4,:);
linwidth=2;

%close all;
%fig=figure(image);
set(gca,'xtick',[])
set(gca,'ytick',[])
if size(scanpath,1)>0
    y=scanpath(:,1);
    x=scanpath(:,2);
    hold on
    plot(y(1),x(1),'Marker','o','MarkerSize',markersize(1),'LineStyle','--','LineWidth',linwidth,'MarkerFaceColor',init_markercolor,'MarkerEdgeColor',markerlinecolor,'Color',markerlinecolor);
    if printtext
        text(y(1)-round(markersize(1)*0.5), x(1), num2str(1),'Color',markertextcolor,'FontSize',markersize(1)*0.5);
    end
    for g=2:size(scanpath,1)
        plot([y(g-1),y(g)],[x(g-1),x(g)],'MarkerSize',1,'LineStyle','--','LineWidth',linwidth,'MarkerFaceColor',markercolor,'MarkerEdgeColor',markerlinecolor,'Color',markerlinecolor);
        plot(y(g),x(g),'Marker','o','MarkerSize',markersize(g),'LineStyle','--','LineWidth',linwidth,'MarkerFaceColor',markercolor,'MarkerEdgeColor',markerlinecolor,'Color',markerlinecolor);
        if printtext
            drawnow
            text(y(g)-round(markersize(g)*0.5), x(g), num2str(g),'Color',markertextcolor,'FontSize',markersize(g)*0.5);
        end
    end
    
    hold off
end
[map,~]= frame2im(getframe);        

end


