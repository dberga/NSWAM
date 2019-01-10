function [  ] = plot_dynamics( model_name, image_path, mat_path, gaze, mask_path )

addpath(genpath('src'));
addpath(genpath('include'));

if nargin < 1, model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'; end
if nargin < 2, image_path=['input_tsotsos/' '111' '.jpg' ]; end %['input_tsotsos/' '111.jpg' ]
if nargin < 3, mat_path=['mats_tsotsos/' model_name ]; end %['mats_tsotsos/' model_name ]
if nargin < 4, gaze = 1; end
if nargin < 5, mask_path=['/home/dberga/repos/metrics_saliency/input/mmaps/tsotsos' '/' '111.png']; end %['/home/dberga/repos/metrics_saliency/input/mmaps/tsotsos' '/' '111.png']

img = imread(image_path);
[filepath,name,ext] = fileparts(image_path);
struct_path=[mat_path '/' name '_struct_gaze' num2str(gaze) '.mat'];

mat=load(struct_path);
struct=mat.matrix_in;
struct.file_params.name=name;
channels={'chromatic','chromatic2','intensity'};

%% feature extraction

%% plot rgb
% plot_rgb(img,struct)

%% Plot Lab
opp_image = get_rgb2opp(img,struct);
%opp_image=normalize_channels(opp_image,-1,1);
% plot_lab(opp_image,struct);

%% Plot DWT
%[struct.wave_params.n_scales, struct.wave_params.ini_scale, struct.wave_params.fin_scale]= calc_scales(opp_image, struct.wave_params.ini_scale, struct.wave_params.fin_scale_offset, struct.wave_params.mida_min, struct.wave_params.multires); % calculate number of scales (n_scales) automatically
%[struct.wave_params.n_orient] = calc_norient(opp_image,struct.wave_params.multires,struct.wave_params.n_scales,struct.zli_params.n_membr);            
[curvs,residuals] = get_DWT(NaN,struct,NaN,NaN,3,1,opp_image);

plot_dwt(curvs,residuals,struct);

if struct.gaze_params.foveate~=0
    [curvs,residuals]=get_foveate_multires(curvs,residuals,struct);
end

plot_dwt(curvs,residuals,struct,'cortical');

%% saliency computation

% load iFactors
for c=1:length(channels)
    iFactor_channel_path=[mat_path '/' name '_iFactor_channel(' channels{c} ')_gaze' num2str(gaze) '.mat']
    mat=load(iFactor_channel_path);
    iFactors{c}=mat.matrix_in;
end

%gx to S
RF_ti_s_o_c = unify_channels_ti(iFactors{1},iFactors{2},iFactors{3},struct);
RF_s_o_c = timatrix_to_matrix(RF_ti_s_o_c,struct);
%residuals to zero
[residuals{1}] = get_residual_updated(struct,residuals{1});
[residuals{2}] = get_residual_updated(struct,residuals{2});
[residuals{3}] = get_residual_updated(struct,residuals{3});
residual_s_c = cs2sc(residuals,3,struct.wave_params.n_scales);
%S to smap
[smap_RF,RF_c ] = get_fusion(RF_s_o_c, residual_s_c,struct);
smap = get_undistort(struct,smap_RF);
smap = get_deresize(struct,smap);
smap = get_normalize(struct,smap);
smap=get_smooth(smap,struct);

% plot_RF(RF_s_o_c,RF_c,struct);

%% plot dynamics

for c=1:length(channels)
    [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(iFactors{c},1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    activity_mean_s{c}=nanmean(activity_mean,2);
    activity_mean_o{c}=nanmean(activity_mean,1);
    activity_mean_c(1,c,:)=nanmean(nanmean(activity_mean,2),1);
    activity_mean_all{c}=activity_mean;
end

% plot_activity1(activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single,struct);

% cut ifactor given mask

try 
    mask=imread(mask_path);
    aoicoords=getaoicoords(mask,35,0);


    for c=1:length(channels)
    croppedmatrix=cropmat(iFactors{c},aoicoords(1),aoicoords(3),aoicoords(2),aoicoords(4)); 
    [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(croppedmatrix,1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    activity_mean_s{c}=nanmean(activity_mean,2);
    activity_mean_o{c}=nanmean(activity_mean,1);
    activity_mean_c(1,c,:)=nanmean(mean(activity_mean,2),1);
    activity_mean_all{c}=activity_mean;
    end

    % plot_activity2(activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single,struct);
catch
    disp('No mask');
end

end

function [] = plot_rgb(img,struct)
    
    mkdir('figs/rgb/');
    img=double(img)/255;

    cmap_red=hsv2rgb([repmat(0/360,1,64)' repmat(1,1,64)' (1/64:1/64:1)' ]);
    cmap_green=hsv2rgb([repmat(120/360,1,64)' repmat(1,1,64)' (1/64:1/64:1)' ]);
    cmap_blue=hsv2rgb([repmat(240/360,1,64)' repmat(1,1,64)' (1/64:1/64:1)' ]);
    cmap_rgb=[cmap_red; cmap_green; cmap_blue];
    imgmod=img;
    imgmod(:,:,1)=imgmod(:,:,1)*1/3;
    imgmod(:,:,2)=imgmod(:,:,2)*1/3+1/3;
    imgmod(:,:,3)=imgmod(:,:,3)*1/3+2/3;
    image_3D_stacked(imgmod); 
    colormap(cmap_rgb); set(gca,'ztick',[]); view(35,44);
    saveas(gcf,['figs/rgb/'  struct.file_params.name '_rgb_sep' '.png']);
    close all;
    colormap(cmap_red); cb=colorbar; set(cb,'position',[.50 .50 .05 .2]); caxis([0 255]);
    colormap(cmap_green); cb=colorbar; set(cb,'position',[.50 .50 .05 .2]);  caxis([0 255]);
    colormap(cmap_blue); cb=colorbar; set(cb,'position',[.50 .50 .05 .2]);  caxis([0 255]);
    close all;
    
    
    image_3D(img(:,:,1),false); colormap(cmap_red); set(gca,'ztick',[]);
    saveas(gcf,['figs/rgb/'  struct.file_params.name '_rgb_sep_red' '.png']);
    image_3D(img(:,:,2),false); colormap(cmap_green); set(gca,'ztick',[]);
    saveas(gcf,['figs/rgb/'  struct.file_params.name '_rgb_sep_green' '.png']);
    image_3D(img(:,:,3),false); colormap(cmap_blue); set(gca,'ztick',[]);
    saveas(gcf,['figs/rgb/'  struct.file_params.name '_rgb_sep_blue' '.png']);
    
    image_3D(img,false);
    set(gca,'ztick',[]);
    saveas(gcf,['figs/rgb/'  struct.file_params.name '_rgb' '.png']);
    close all;
    
    
end

function [] = plot_lab(opp_image,struct)

mkdir('figs/lab/');
% mosaic = zeros(size(opp_image,1),size(opp_image,2),1,size(opp_image,3)); 
% mosaic(:,:,1,:) = opp_image(:,:,:);
% figure; [fig] = montage(mosaic, 'Size',[1 3]);
% close all;
% if struct.gaze_params.foveate==1
%     [opp_image_foveated] = get_foveate(opp_image,struct);
%     mosaic = zeros(size(opp_image_foveated,1),size(opp_image_foveated,2),1,size(opp_image_foveated,3)); 
%     mosaic(:,:,1,:) = opp_image_foveated(:,:,:);
%     figure; [fig] = montage(mosaic, 'Size',[1 3]);
%     close all;
% end
image_3D(opp_image(:,:,1))
colormap_opp(1) %a
cb=colorbar; set(gca,'ztick',[]); set(cb,'position',[.10 .75 .05 .2]); caxis([-1 1]); 
% savefig(['figs/lab/' struct.file_params.name '_'  'a' '.fig']);
% fig2png(['figs/lab/'  struct.file_params.name '_' 'a' '.fig'],['figs/' struct.file_params.name '_'  'a' '.png']);
saveas(gcf,['figs/lab/' struct.file_params.name '_'  'a' '.png']);
close all;
image_3D(opp_image(:,:,2))
colormap_opp(2) %b
cb=colorbar;  set(gca,'ztick',[]); set(cb,'position',[.10 .75 .05 .2]); caxis([-2 1]); 
% savefig(['figs/lab/' struct.file_params.name '_'  'b' '.fig']);
% fig2png(['figs/lab/' struct.file_params.name '_'  'b' '.fig'],['figs/'  struct.file_params.name '_' 'b' '.png']);
saveas(gcf,['figs/lab/' struct.file_params.name '_'  'b' '.png']);
close all; 
image_3D(opp_image(:,:,3))
colormap_opp(3) %L
cb=colorbar; set(gca,'ztick',[]); set(cb,'position',[.10 .75 .05 .2]); caxis([0 3]); 
% savefig(['figs/lab/' struct.file_params.name '_'  'L' '.fig']);
% fig2png(['figs/lab/' struct.file_params.name '_'  'L' '.fig'],['figs/'  struct.file_params.name '_' 'L' '.png']);
saveas(gcf,['figs/lab/' struct.file_params.name '_'  'L' '.png']);
close all;

end


function [] = plot_dwt(curvs,residuals,struct,suffix)

mkdir('figs/dwt/');
if nargin<4, suffix=''; end

% for c=1:length(channels)
%     figure; [fig] = show_wav(curvs{c},1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
%     close all;
% end

for c=1:length(struct.color_params.channels)
    lgn=so2mat(curvs{c});
    for o=1:size(lgn,4)
        figure, image_3D_stacked(lgn(:,:,:,o));
        colormap_opp(c); set(gca,'xtick',[]); set(gca,'ytick',[]); set(gca,'ztick',[]); axis off %cb=colorbar; set(cb,'position',[.10 .75 .05 .2]);
        saveas(gcf,['figs/dwt/' struct.file_params.name '_' 'dwt' '_' suffix '_' 'c' int2str(c) '_' 'o' int2str(o) '.png']);
    end
    close all;
end

end


function [] = plot_RF(RF_s_o_c,RF_c,struct)


%draw maps
RF_c_s_o=soc2cso(RF_s_o_c,size(RF_s_o_c{1}{1},3),length(RF_s_o_c),length(RF_s_o_c{1}));
for c=1:length(struct.color_params.channels)
    RFmat=rf2mat(RF_c_s_o{c});
    for o=1:size(RFmat,4)
        image_3D_stacked(RFmat(:,:,:,o));
        title(['c=' int2str(c) ',o=' int2str(o)]);
    end
    close all;
end
%image_3D_stacked(RF_c);
%close all;

% for c=1:length(RF_s_o_c)
%     for s=1:length(RF_s_o_c{c})-1
%         for o=1:3
%             image_3D(RF_s_o_c{c}{s}(:,:,o)); 
%             set(gcf,'units','points','position',[10,10,200,200]);
%             xticks([]);
%             yticks([]);
%             zticks([0,1,2]); zlim([-2,2]);
%             savefig(['figs/' struct.file_params.name '_'  'o' num2str(c) 's' num2str(s) 'o' num2str(o) '.fig']);
%             fig2png(['figs/' struct.file_params.name '_'  'o' num2str(c) 's' num2str(s) 'o' num2str(o) '.fig'],['figs/'  struct.file_params.name '_' 'o' num2str(c) 's' num2str(s) 'o' num2str(o) '.png']);
%             close all;
%         end
%     end
% end
% %image_3D(RF_c(:,:,c));
%close all;
%image_3D(smap);
%close all;
end

function [] = plot_activity1(activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single,struct)

%% COD (channel opponency dynamics)
[fig] = show_activity_plots(activity_mean_c);
[fig]= show_activity_plots_mult(activity_mean_c);
[fig]= show_phase_plots(activity_mean_c);
[fig]= show_phase_plots_mult(activity_mean_c);
close all;
    
for c=1:length(struct.color_params.channels)
    
    %% SFD (spatial frequency dynamics)
    [fig] = show_activity_plots_mult(activity_mean_s{c});
    [fig]= show_phase_plots(activity_mean_s{c});
    close all;
    
    
    %% OSD (orientation sensitivity dynamics)
    [fig] = show_activity_plots_mult(activity_mean_o{c});
    close all;
    
    
    %% RF figures
%     [figs] = show_RF_dynamic(iFactors{c},1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
%     close all;
%     Dynamics from all feature maps
%     [fig] = show_activity_plots(activity_mean_all{c});
%     close all;

end

end

function [] = plot_activity2(activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single,struct)
%% COD (channel opponency dynamics)

% [fig] = show_activity_plots(activity_mean_c);
[fig]= show_activity_plots_mult(activity_mean_c);
fig.Children.Children(3).Color=[1 0 0];
fig.Children.Children(2).Color=[0 0 1];
fig.Children.Children(1).Color=[0 0 0];
legend({'a* [r/g]','b* [b/y]','L* (I)'});
xlabel('# iter (ms)');
ylabel('Firing Rate (spikes/s)');
% [fig]= show_phase_plots(activity_mean_c);
%[fig]= show_phase_plots_mult(activity_mean_c);
set(gcf,'units','points','position',[10,10,300,250])
savefig(['figs/' struct.file_params.name '_' 'COD'  '.fig']);
fig2png(['figs/' struct.file_params.name '_' 'COD'  '.fig'],['figs/' struct.file_params.name '_' 'COD'  '.png']);
close all;

[fig]=plot_raster2(squeeze(activity_mean_c));
xlabel('# iter (ms)');
ylabel('');
yticklabels({'a*','b*','L*'});
set(gcf,'units','points','position',[10,10,400,250])
savefig(['figs/' struct.file_params.name '_'  'COD_st'  '.fig']);
fig2png(['figs/'  struct.file_params.name '_' 'COD_st'  '.fig'],['figs/'  struct.file_params.name '_' 'COD_st'  '.png']);
close all;
    
for c=1:length(struct.color_params.channels)
    
    %% SFD (spatial frequency dynamics)
    [fig] = show_activity_plots_mult(activity_mean_s{c});
    fig.Children.Children(5).Color=[0.8 0.8 0.8];
    fig.Children.Children(4).Color=[0.6 0.6 0.6];
    fig.Children.Children(3).Color=[0.4 0.4 0.4];
    fig.Children.Children(2).Color=[0.2 0.2 0.2];
    fig.Children.Children(1).Color=[0 0 0];
    fig.Children.Children(5).LineStyle=':';
    fig.Children.Children(4).LineStyle=':';
    fig.Children.Children(3).LineStyle='-.';
    fig.Children.Children(2).LineStyle='--';
    fig.Children.Children(1).LineStyle='-';
    legend({'\oslash(\Psi_{s1})=.23 deg','\oslash(\Psi_{s2})=.46 deg','\oslash(\Psi_{s3})=.91 deg','\oslash(\Psi_{s4})=1.83 deg','\oslash(\Psi_{s5})=3.66 deg'});
    xlabel('# iter (ms)');
    ylabel('Firing Rate (spikes/s)');
    %8,16,32,64,128,256
    %[fig]= show_phase_plots(activity_mean_s{c});
    set(gcf,'units','points','position',[10,10,300,250])
    savefig(['figs/' struct.file_params.name '_'  'SFD'  '.fig']);
    fig2png(['figs/' struct.file_params.name '_'  'SFD'  '.fig'],['figs/' struct.file_params.name '_'  'SFD'  '.png']);
    close all;
    
    
    [fig]=plot_raster2(squeeze(activity_mean_s{c}));
    xlabel('# iter (ms)');
    ylabel('');
    yticklabels({'\Psi_{s1}','\Psi_{s2}','\Psi_{s3}','\Psi_{s4}','\Psi_{s5}'});
    set(gcf,'units','points','position',[10,10,400,250])
    savefig(['figs/' struct.file_params.name '_'  'SFD_st'  '.fig']);
    fig2png(['figs/'  struct.file_params.name '_' 'SFD_st'  '.fig'],['figs/' struct.file_params.name '_'  'SFD_st'  '.png']);
    close all;

    %% OSD (orientation sensitivity dynamics)
    [fig] = show_activity_plots_mult(activity_mean_o{c});
    fig.Children.Children(3).Color=[1 0 0];
    fig.Children.Children(2).Color=[0 1 1];
    fig.Children.Children(1).Color=[.5 1 0];
    legend({'\theta=h','\theta=v','\theta=d'});
    xlabel('# iter (ms)');
    ylabel('Firing Rate (spikes/s)');
    set(gcf,'units','points','position',[10,10,300,250])
    savefig(['figs/' struct.file_params.name '_'  'OSD'  '.fig']);
    fig2png(['figs/'  struct.file_params.name '_' 'OSD'  '.fig'],['figs/' struct.file_params.name '_'  'OSD'  '.png']);
    close all;
    
    [fig]=plot_raster2(squeeze(activity_mean_o{c}));
    xlabel('# iter (ms)');
    ylabel('');
    yticklabels({'\theta=h','\theta=v','\theta=d'});
    set(gcf,'units','points','position',[10,10,400,250])
    savefig(['figs/' struct.file_params.name '_'  'OSD_st'  '.fig']);
    fig2png(['figs/'  struct.file_params.name '_' 'OSD_st'  '.fig'],['figs/' struct.file_params.name '_'  'OSD_st'  '.png']);
    close all;
    
    %% RF figures
    %[figs] = show_RF_dynamic(iFactors{c},1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    %close all;
    %Dynamics from all feature maps
    %[fig] = show_activity_plots(activity_mean_all{c});
    %close all;
    
end


end
