function [  ] = plot_iormaps( model_name, image_path, mat_path, mask_path )


if nargin < 1, model_name='ior_decay99_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault'; end
if nargin < 2, image_path=['input_tsotsos/' '111' '.png' ]; end %['input_tsotsos/' '111.jpg' ]
if nargin < 3, mat_path=['mats_tsotsos/' model_name ]; end %['mats_tsotsos/' model_name ]
if nargin < 4, mask_path=['/home/dberga/repos/metrics_saliency/input/mmaps/tsotsos' '/' '111.png']; end %['/home/dberga/repos/metrics_saliency/input/mmaps/tsotsos' '/' '111.png']

img = imread(image_path);
[filepath,name,ext] = fileparts(image_path);

G=10;
for g=1:G
    struct_path=[mat_path '/' name '_struct_gaze' num2str(g) '.mat'];
    load(struct_path);
    
    %imagesc(cummax_reduc(matrix_in.gaze_params.ior_matrix_multidim));
    imagesc(matrix_in.gaze_params.ior_matrix);
    colormap(jet);
    
    ior_matrix_unfoveated = get_ior_gaussian(matrix_in.gaze_params.fov_x,matrix_in.gaze_params.fov_y, matrix_in);
    imagesc(ior_matrix_unfoveated);
    colormap(jet);
end


end


