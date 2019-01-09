function [ map ] = visualize_scanpath2( image, scanpath, scanpath_times )

tpf=300; %if scanpath does not provide time, set default as 300
if nargin < 3 && size(scanpath,2) > 3
    scanpath_times=scanpath(:,3:4);
else
    f=1:size(scanpath,1);
    scanpath_times(:,1)=tpf.*f - tpf;
    scanpath_times(:,2)=tpf.*f;
end

fixtime=scanpath_times(:,2)-scanpath_times(:,1);
%markersize= round(fixtime*(10/tpf)+10);
markersize(1:size(scanpath,1))= 7;
init_markercolor=[0 1 0];
markercolor=[0 1 0];
linwidth=2;

close all;
fig=imagesc(image);
set(gca,'xtick',[])
set(gca,'ytick',[])
if size(scanpath,1)>0
    y=scanpath(:,1);
    x=scanpath(:,2);
    hold on
    plot(y(1),x(1),'--go','MarkerSize',markersize(1),'LineWidth',linwidth,'MarkerFaceColor',init_markercolor);
    %text(y(1)-round(markersize(1)*0.5), x(1), num2str(1),'Color','red','FontSize',markersize(1)*0.5);
    for g=2:size(scanpath,1)
        plot([y(g-1),y(g)],[x(g-1),x(g)],'g--','MarkerSize',1,'LineWidth',linwidth);
        plot(y(g),x(g),'--go','MarkerSize',markersize(g),'LineWidth',linwidth,'MarkerFaceColor',markercolor);
        
        %drawnow
        %text(y(g)-round(markersize(g)*0.5), x(g), num2str(g),'Color','red','FontSize',markersize(g)*0.5);
    end
    
    hold off
end
[map,~]= frame2im(getframe);        

end

