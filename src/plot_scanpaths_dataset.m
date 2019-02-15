function [  ] = plot_scanpaths( input_dataset, output_folder, model_name )

if nargin<1, input_dataset='input_tsotsos'; end
if nargin<2, output_folder='output_tsotsos'; end
if nargin<3, model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'; end

files=listpath(input_dataset);

mkdir('figs/scanpaths');
for f=1:length(files)
    [imgfolder,imgname,imgext]=fileparts([input_dataset '/' files{f}]);
    if ~exist(['figs' '/' 'scanpaths'  '/' model_name '_' imgname '.png'],'file')
    img=im2double(imread([input_dataset '/' files{f}]));
    load([output_folder '/' model_name '/' 'scanpath' '/' imgname '.mat']);
    superpos_sp=superpos_scanpath( img,scanpath,10,40 ,[ 0 1 0;1 0 0; 1 0 0; 0 0 0]);
    imwrite2(superpos_sp,['figs' '/' 'scanpaths'  '/' model_name '_' imgname '.png']);
    end
end



end

