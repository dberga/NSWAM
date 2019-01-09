function [  ] = plot_scanpaths( input_dataset, output_folder, model_name )

if nargin<1, input_dataset='input_tsotsos'; end
if nargin<2, output_folder='output_tsotsos'; end
if nargin<3, model_name='no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'; end

files=listpath(input_dataset);

for f=1:length(files)
    try 
    [imgfolder,imgname,imgext]=fileparts([input_dataset '/' files{f}]);
    img=im2double(imread([input_dataset '/' files{f}]));
    load([output_folder '/' model_name '/' 'scanpath' '/' imgname '.mat']);
    superpos_sp=superpos_scanpath( img,scanpath,10,40 );
    imwrite(superpos_p,['figs' '/' 'scanpath_' imgname '.png']);
    end
end



end

