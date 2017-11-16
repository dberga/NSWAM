function [ fig ] = visualize_scanpath( image, scanpath, scanpath_times )

tpf=300; %if scanpath does not provide time, set default as 300
if nargin < 3 && size(scanpath,2) > 3
    scanpath_times=scanpath(:,3:4);
else
    f=1:size(scanpath,1);
    scanpath_times(:,1)=tpf.*f - tpf;
    scanpath_times(:,2)=tpf.*f;
end

fixtime=scanpath_times(:,2)-scanpath_times(:,1);

x=scanpath(:,1);
y=scanpath(:,2);
markersize= fixtime*(10/tpf)+10;




figure;
fig=imagesc(image);
hold on
%plot(y,x,'y.','MarkerSize',markersize);
for g=1:size(scanpath,1)
plot(x(g),y(g),'--go',...
    'LineWidth',2,...
    'MarkerSize',markersize(g),...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
text(x(g)-round(markersize(g)*0.5), y(g), num2str(g));
end

hold off


end

