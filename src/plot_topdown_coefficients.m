function [  ] = plot_topdown_coefficients( model_name, image_path, mat_path, gaze, mask_path )
addpath(genpath('src'));
addpath(genpath('include'));

if nargin < 1, model_name='topdown_single_config_b1_15_fusion2'; end
if nargin < 2, image_path=['input/' '111' '.png' ]; end %['input_tsotsos/' '111.jpg' ]
if nargin < 3, mat_path=['mats_tsotsos/' model_name ]; end %['mats_tsotsos/' model_name ]
if nargin < 4, gaze = 1; end
%if nargin < 5, mask_path=['/home/dberga/repos/metrics_saliency/input/mmaps/tsotsos' '/' '111.png']; end %['/home/dberga/repos/metrics_saliency/input/mmaps/tsotsos' '/' '111.png']
if nargin < 5, mask_path=['input/masks' '/' '111b.png']; end 
%target_features_path=['input_tsotsos/target_features/' model_name '/' '111.mat'];
%load(target_features_path);

img = im2double(imread(image_path));
mask = im2double(imread(mask_path));
[filepath,name,ext] = fileparts(image_path);
[filepath2,name2,ext2] = fileparts(mask_path);
struct_path=[mat_path '/' name '_struct_gaze' num2str(gaze) '.mat'];
load(struct_path);
struct=matrix_in;

target_features=template2params( img, mask, struct );
struct.search_params.channels=target_features.channels;
struct.search_params.scales=target_features.scales;
struct.search_params.orientations=target_features.orientations;
struct.search_params.polarity=target_features.polarity;
struct.search_params.coefficients=target_features.coefficients;
matrix_in=target_features;


S=size(target_features.coefficients,1);
O=size(target_features.coefficients,2);
P=size(target_features.coefficients,3);
C=size(target_features.coefficients,4);
% values_onoff_parvo=abs(target_features.coefficients(:,:,1,1))-abs(target_features.coefficients(:,:,2,1));
% values_onoff_konio=abs(target_features.coefficients(:,:,1,2))-abs(target_features.coefficients(:,:,2,2));
% values_onoff_magno=abs(target_features.coefficients(:,:,1,3))-abs(target_features.coefficients(:,:,2,3));
% 
% colors_parvo=[1 0 0; 0 1 0];
% colors_konio=[1 1 0; 0 0 1];
% colors_magno=[1 1 0; 0 0 0];

mkdir(['figs/topdown_coefficients/']);

%% plot coefficients
close all;
hold on
hb=bar(target_features.coefficients(:,:,1,1),'red');
hb=bar(-target_features.coefficients(:,:,2,1),'green');
hold off
ylim([-1 1]);
xlim([0 S+1]);
% ylabel('OFF/ON');
xticks([]);
% xlabel('\leftarrow Scale \rightarrow');
yticks([]);
set(gcf, 'Position',  [10, 10, 100, 50]);
saveas2(gcf,['figs/topdown_coefficients/' model_name '_' name2 '_a' '.png']);

close all;
hold on
hb=bar(target_features.coefficients(:,:,1,2),'yellow');
hb=bar(-target_features.coefficients(:,:,2,2),'blue');
hold off
ylim([-1 1]);
xlim([0 S+1]);
% ylabel('OFF/ON');
xticks([]);
% xlabel('\leftarrow Scale \rightarrow');
yticks([]);
set(gcf, 'Position',  [10, 10, 100, 50]);
saveas2(gcf,['figs/topdown_coefficients/' model_name '_' name2 '_b' '.png']);

close all;
hold on
hb=bar(target_features.coefficients(:,:,1,3),'FaceColor',[0.9 0.9 0.9]);
hb=bar(-target_features.coefficients(:,:,2,3),'black');
hold off
ylim([-1 1]);
xlim([0 S+1]);
% ylabel('OFF/ON');
xticks([]);
% xlabel('\leftarrow Scale \rightarrow');
yticks([]);
set(gcf, 'Position',  [10, 10, 100, 50]);
saveas2(gcf,['figs/topdown_coefficients/' model_name '_' name2 '_L' '.png']);


%% plot mask 
close all;
image_3D_stacked(im2double(mask));
view(35,44);
xticks([]);
yticks([]);
zticks([]);
axis off
colormap(gray);
saveas2(gcf,['figs/topdown_coefficients/' model_name '_' name2 '_mask3D' '.png']);

end


