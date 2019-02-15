
close all;

figure(1); cla; hold on;
decay_list=[.9:0.001:1];%[0,.25,.5,.75,.9,.9900:0.0001:1];%[0 .25 .5 .75 .9 .99 .999 1]; %
iter_per_gaze=100;
num_iter=1000+iter_per_gaze;
colors=imresize(spring,[length(decay_list),3]); colors(colors(:)<0)=0;colors(colors(:)>1)=1;
for ctt=1:length(decay_list)
    dtt=decay_list(ctt);
    color = colors(ctt,:);
     factor = ones(1,num_iter);
     factor(1:iter_per_gaze)=1;
    for count=2+iter_per_gaze:num_iter
        factor(1,count) = get_ior_factor(factor(1,count-1),dtt);
    end
    plot(1:num_iter,factor,'color',color,'LineWidth',2); 
end
if length(decay_list)<10,
    legend([repmat('\alpha_{Ior}=',length(decay_list),1), num2str(decay_list')]);
end
cbh=colorbar; 
cbh.Parent.Colormap=colors;
caxis([decay_list(1) decay_list(end)]);
set(gcf, 'Position',  [100, 100, 400, 200]);
xlim([0 num_iter]);
xlabel('iter');
ylabel('I_{ior}');
colorTitleHandle = get(cbh,'Title');
set(colorTitleHandle ,'String','\alpha_{Ior}');
set(cbh,'YTick',[0 .9 .95 .99 1]);

close all;
pxva=40; %35
sigma_list=[pxva*1 pxva*2 pxva*4 pxva*8];
M=200;
N=300;
sample_ior=zeros(M,N);
fov_x=round(N*0.5);
fov_y=round(M*0.5);
%axis off
for s=1:length(sigma_list)
    conf_struct.gaze_params.maxidx_s=NaN;
    conf_struct.wave_params.ini_scale=NaN;
    conf_struct.wave_params.fin_scale=NaN;
    conf_struct.wave_params.mida_min=NaN;
    conf_struct.gaze_params.orig_height=M;
    conf_struct.gaze_params.orig_width=N;
    conf_struct.gaze_params.img_diag_angle=deg2rad(pxva);
    conf_struct.gaze_params.ior_angle=deg2rad(s);
    gaussian=get_ior_gaussian( fov_x, fov_y,conf_struct);
    subplot(1,length(sigma_list),s);
    h=imagesc(gaussian);
    %colormap('jet');
    xlabel(['\sigma_{Ior}=' num2str(s) ' deg']);
    h.Parent.YTick=[];
    h.Parent.XTick=[];
end
set(gcf, 'Position',  [100, 100, 600, 100]);
%shading interp;
%image(Z,'CDataMapping','scaled')
