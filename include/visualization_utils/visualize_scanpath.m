function [ map ] = visualize_scanpath( image, scanpath, scanpath_times )

tpf=300; %if scanpath does not provide time, set default as 300
if nargin < 3 && size(scanpath,2) > 3
    scanpath_times=scanpath(:,3:4);
else
    f=1:size(scanpath,1);
    scanpath_times(:,1)=tpf.*f - tpf;
    scanpath_times(:,2)=tpf.*f;
end

fixtime=scanpath_times(:,2)-scanpath_times(:,1);
markersize= fixtime*(10/tpf)+10;


close all;
fig=imagesc(image);
set(gca,'xtick',[])
set(gca,'ytick',[])
if size(scanpath,1)>0
    y=scanpath(:,1);
    x=scanpath(:,2);

    hold on
    %plot(y,x,'y.','MarkerSize',markersize);
    for g=1:size(scanpath,1)
    plot(y(g),x(g),'--go',...
        'LineWidth',2,...
        'MarkerSize',markersize(g),...
        'MarkerEdgeColor','b',...
        'MarkerFaceColor',[0.5,0.5,0.5]);
    text(y(g)-round(markersize(g)*0.5), x(g), num2str(g));
    end
    hold off
end

[map,~]= frame2im(getframe);  
end

