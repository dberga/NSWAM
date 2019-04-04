function [  ] = plot_iormaps( model_name, image_path, mat_path, mask_path )


if nargin < 1, model_name='ior_decay99_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault'; end
if nargin < 2, image_path=['input_tsotsos/' '111' '.png' ]; end %['input_tsotsos/' '111.jpg' ]
if nargin < 3, mat_path=['mats_tsotsos/' model_name ]; end %['mats_tsotsos/' model_name ]
if nargin < 4, mask_path=['/home/dberga/repos/metrics_saliency/input/mmaps/tsotsos' '/' '111.png']; end %['/home/dberga/repos/metrics_saliency/input/mmaps/tsotsos' '/' '111.png']

img = imread(image_path);
[filepath,name,ext] = fileparts(image_path);

G=10;
for g=1:G
    g
    struct_path=[mat_path '/' name '_struct_gaze' num2str(g) '.mat'];
    load(struct_path);
    mkdir('figs/ior');
    
    %imagesc(cummax_reduc(matrix_in.gaze_params.ior_matrix_multidim));
    %imagesc(matrix_in.gaze_params.ior_matrix);
    %colormap(jet);
    matrix_in.gaze_params.fov_x=447;
    matrix_in.gaze_params.fov_y=192;
    
    ior_matrix_unfoveated = get_ior_gaussian(matrix_in.gaze_params.fov_x, matrix_in.gaze_params.fov_y,matrix_in);
    ior_matrix_foveated = foveate(ior_matrix_unfoveated,0,matrix_in);
    
    close all
    image_3D(ior_matrix_unfoveated)
    %plot_peaks(ior_matrix_unfoveated,matrix_in)
    axis off
    view(35,29);
    colormap(jet);
    saveas(gcf,['figs/ior/' name '.png']);
    
    close all
    image_3D_stacked(ior_matrix_foveated)
    %plot_peaks(ior_matrix_unfoveated,matrix_in)
    axis off
    view(31,38);
    colormap(jet);
    saveas(gcf,['figs/ior/cortical_' name '.png']);
end


end


