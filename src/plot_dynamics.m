function [  ] = plot_dynamics( image_path, mat_path, gaze, mask_path )

addpath(genpath('include'));

model_name='no_cortical_config_b1_15';

if nargin < 1, image_path=['input_tsotsos/' '72.jpg' ]; end
if nargin < 2, mat_path=['mats_tsotsos/' model_name ]; end
if nargin < 3, gaze = 1; end
if nargin < 4, mask_path=['/home/dberga/repos/metrics_saliency/input/mmaps/tsotsos' '/' '72.png']; end

img = imread(image_path);
[filepath,name,ext] = fileparts(image_path);
struct_path=[mat_path '/' name '_struct_gaze' num2str(gaze) '.mat'];

mat=load(struct_path);
struct=mat.matrix_in;

channels={'chromatic','chromatic2','intensity'};

%% Plot Lab
opp_image = get_rgb2opp(img,struct);
mosaic = zeros(size(img,1),size(img,2),1,size(img,3)); 
mosaic(:,:,1,:) = opp_image(:,:,:);
figure; [fig] = montage(mosaic, 'Size',[1 3]);
close all;
    
%% Plot DWT
%[struct.wave_params.n_scales, struct.wave_params.ini_scale, struct.wave_params.fin_scale]= calc_scales(opp_image, struct.wave_params.ini_scale, struct.wave_params.fin_scale_offset, struct.wave_params.mida_min, struct.wave_params.multires); % calculate number of scales (n_scales) automatically
%[struct.wave_params.n_orient] = calc_norient(opp_image,struct.wave_params.multires,struct.wave_params.n_scales,struct.zli_params.n_membr);            
[curvs,residuals] = get_DWT(NaN,struct,NaN,NaN,3,1,opp_image);

for c=1:length(channels)
    figure; [fig] = show_wav(curvs{c},1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    close all;
end

%% load iFactors
for c=1:length(channels)
    iFactor_channel_path=[mat_path '/' name '_iFactor_channel(' channels{c} ')_gaze' num2str(gaze) '.mat']
    mat=load(iFactor_channel_path);
    iFactors{c}=mat.matrix_in;
    
    [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(iFactors{c},1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    activity_mean_s{c}=mean(activity_mean,2);
    activity_mean_o{c}=mean(activity_mean,1);
    activity_mean_c(1,c,:)=mean(mean(activity_mean,2),1);
    activity_mean_all{c}=activity_mean;
end

%% COD (channel opponency dynamics)
% [fig] = show_activity_plots(activity_mean_c);
%[fig]= show_activity_plots_mult(activity_mean_c);
% [fig]= show_phase_plots(activity_mean_c);
%[fig]= show_phase_plots_mult(activity_mean_c);
%close all;
    
for c=1:length(channels)
    
    %% SFD (spatial frequency dynamics)
    %[fig] = show_activity_plots_mult(activity_mean_s{c});
    %[fig]= show_phase_plots(activity_mean_s{c});
    %close all;
    
    
    %% OSD (orientation sensitivity dynamics)
    %[fig] = show_activity_plots_mult(activity_mean_o{c});
    %close all;
    
    
    %% RF figures
    %[figs] = show_RF_dynamic(iFactors{c},1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    %close all;
    %Dynamics from all feature maps
    %[fig] = show_activity_plots(activity_mean_all{c});
    %close all;
    
end
%% cut ifactor given mask
mask=imread(mask_path);
aoicoords=getaoicoords(mask,35,0);


for c=1:length(channels)
    croppedmatrix=cropmat(iFactors{c},aoicoords(1),aoicoords(3),aoicoords(2),aoicoords(4)); 
    [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(croppedmatrix,1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    activity_mean_s{c}=mean(activity_mean,2);
    activity_mean_o{c}=mean(activity_mean,1);
    activity_mean_c(1,c,:)=mean(mean(activity_mean,2),1);
    activity_mean_all{c}=activity_mean;
end
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
savefig(['COD'  '.fig']);
fig2png(['COD'  '.fig'],['COD'  '.png']);
close all;

[fig]=plot_raster2(squeeze(activity_mean_c));
xlabel('# iter (ms)');
ylabel('');
yticklabels({'a*','b*','L*'});
set(gcf,'units','points','position',[10,10,400,250])
savefig(['COD_st'  '.fig']);
fig2png(['COD_st'  '.fig'],['COD_st'  '.png']);
close all;
    
for c=1:length(channels)
    
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
    savefig(['SFD'  '.fig']);
    fig2png(['SFD'  '.fig'],['SFD'  '.png']);
    close all;
    
    
    [fig]=plot_raster2(squeeze(activity_mean_s{c}));
    xlabel('# iter (ms)');
    ylabel('');
    yticklabels({'\Psi_{s1}','\Psi_{s2}','\Psi_{s3}','\Psi_{s4}','\Psi_{s5}'});
    set(gcf,'units','points','position',[10,10,400,250])
    savefig(['SFD_st'  '.fig']);
    fig2png(['SFD_st'  '.fig'],['SFD_st'  '.png']);
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
    savefig(['OSD'  '.fig']);
    fig2png(['OSD'  '.fig'],['OSD'  '.png']);
    close all;
    
    [fig]=plot_raster2(squeeze(activity_mean_o{c}));
    xlabel('# iter (ms)');
    ylabel('');
    yticklabels({'\theta=h','\theta=v','\theta=d'});
    set(gcf,'units','points','position',[10,10,400,250])
    savefig(['OSD_st'  '.fig']);
    fig2png(['OSD_st'  '.fig'],['OSD_st'  '.png']);
    close all;
    
    %% RF figures
    %[figs] = show_RF_dynamic(iFactors{c},1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    %close all;
    %Dynamics from all feature maps
    %[fig] = show_activity_plots(activity_mean_all{c});
    %close all;
    
end

end

