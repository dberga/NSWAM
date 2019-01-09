function [ ] = plot_dynamics_dataset( model_name, dataset_name)


addpath(genpath('include'));

if nargin<1, model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'; end
if nargin<2, dataset_name='tsotsos'; end

images_list=listpath(['input_' dataset_name]);
mat_path=['mats_' dataset_name '/' model_name ];
gaze = 1;
for i=1:length(images_list)
    image_path=['input_' dataset_name '/' images_list{i} ];
    mask_path=['/home/dberga/repos/metrics_saliency/input/mmaps/' dataset_name '/' images_list{i} '.png']; 
    plot_dynamics(model_name, image_path, mat_path, gaze, mask_path );
end

