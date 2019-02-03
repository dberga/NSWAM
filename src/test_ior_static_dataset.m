function [ ] = test_ior_static_dataset( dataset_name )

if nargin<1, dataset_name='tsotsos'; end
input_dataset_path=['input_' dataset_name];

images_list=listpath(input_dataset_path);

mean_samplitude_diffs=[];
mean_slandings=[];
for i=1:length(images_list)
    img_path=[input_dataset_path '/' images_list{i}];
    model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
    dataset_out_path=['output_' dataset_name];
    GT_path=['/home/dberga/repos/metrics_saliency/input/scanpaths' '/' dataset_name];
    gazesnum=10;
    ior_decay=[0.999];
    ior_peak=1; 
    pxva=40;
    ior_std_angle=[pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7];
    [mean_samplitude_diffs(i,:), mean_slandings(i,:)] = test_ior_static( img_path, model_name,dataset_out_path, GT_path, gazesnum, ior_decay,ior_peak,ior_std_angle );
end
plot_errorbar(ior_std_angle,nanmean(mean_samplitude_diffs,1),nanstd(mean_samplitude_diffs,1))
plot_errorbar(ior_std_angle,nanmean(mean_slandings,1),nanstd(mean_slandings,1))

mean_samplitude_diffs=[];
mean_slandings=[];
for i=1:length(images_list)
    img_path=[input_dataset_path '/' images_list{i}];
    model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault';
    dataset_out_path=['output_' dataset_name];
    GT_path=['/home/dberga/repos/metrics_saliency/input/scanpaths' '/' dataset_name];
    gazesnum=10;
    ior_decay=[0.999 0.99 0.9 0.75 0];
    ior_peak=1; 
    pxva=40;
    ior_std_angle=[pxva*2];
    [mean_samplitude_diffs(i,:), mean_slandings(i,:)] = test_ior_static( img_path, model_name,dataset_out_path, GT_path, gazesnum, ior_decay,ior_peak,ior_std_angle );
end
plot_errorbar(ior_decay,nanmean(mean_samplitude_diffs,1),nanstd(mean_samplitude_diffs,1))
plot_errorbar(ior_decay,nanmean(mean_slandings,1),nanstd(mean_slandings,1))


end

