function [  ] = plot_dynamics( image_path, mat_path, gaze )
if nargin < 3, gaze = 1; end

img = imread(image_path);
[filepath,name,ext] = fileparts(image_path);
struct_path=[mat_path '/' name '_struct_gaze' num2str(gaze) '.mat'];

mat=load(struct_path);
struct=mat.matrix_in;

channels={'chromatic','chromatic2','intensity'};

%Plot Lab
opp_image = get_rgb2opp(img,struct);
mosaic = zeros(size(img,1),size(img,2),1,size(img,3)); 
mosaic(:,:,1,:) = opp_image(:,:,:);
figure; [fig] = montage(mosaic, 'Size',[1 3]);
close all;
    
%Plot DWT
%[struct.wave_params.n_scales, struct.wave_params.ini_scale, struct.wave_params.fin_scale]= calc_scales(opp_image, struct.wave_params.ini_scale, struct.wave_params.fin_scale_offset, struct.wave_params.mida_min, struct.wave_params.multires); % calculate number of scales (n_scales) automatically
%[struct.wave_params.n_orient] = calc_norient(opp_image,struct.wave_params.multires,struct.wave_params.n_scales,struct.zli_params.n_membr);            
[curvs,residuals] = get_DWT(NaN,struct,NaN,NaN,3,1,opp_image);

for c=1:length(channels)
    figure; [fig] = show_wav(curvs{c},1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    close all;
end

%load iFactors
for c=1:length(channels)
    iFactor_channel_path=[mat_path '/' name '_iFactor_channel(' channels{c} ')_gaze' num2str(gaze) '.mat']
    mat=load(iFactor_channel_path);
    iFactors{c}=mat.matrix_in;
    [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(iFactors{c},1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    activity_mean_s{c}=mean(activity_mean,2);
    activity_mean_o{c}=mean(activity_mean,1);
    activity_mean_c(1,c,:)=mean(mean(activity_mean,2),1);
end

%COD (channel opponency dynamics)
[fig] = show_activity_plots_mult(activity_mean_c);
[fig]= show_activity_plots_mult(activity_mean_c);
[fig]= show_phase_plots(activity_mean_c);
[fig]= show_phase_plots_mult(activity_mean_c);
close all;
    
for c=1:length(channels)
    
    %SFD (spatial frequency dynamics)
    [fig] = show_activity_plots_mult(activity_mean_s{c});
    [fig]= show_phase_plots(activity_mean_s{c});
    close all;
    
    
    %OSD (orientation sensitivity dynamics)
    [fig] = show_activity_plots_mult(activity_mean_o{c});
    close all;
    
    
    %RF figures
    [figs] = show_RF_dynamic(iFactors{c},1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    close all;
    %Dynamics from all feature maps
    [fig] = show_activity_plots(activity_mean);
    close all;
    
end
%to do: cut ifactor given mask

end

