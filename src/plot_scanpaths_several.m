function [  ] = plot_scanpaths_several(img_path, model_names , dataset_out_path  )
    if nargin <1, img_path=['input/111.png']; end
    if nargin <2, model_names={'no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; end
    if nargin <3, dataset_out_path='output_tsotsos'; end
    
    [imgfolder,imgname,imgext]=fileparts(img_path);
    img=double(imread(img_path))./255;
    
    mkdir(['figs' '/scanpaths']);
    for m=1:length(model_names)
           scanpath_path=[dataset_out_path '/' model_names{m} '/scanpath/' imgname '.mat'];
           load(scanpath_path);
           try
           superpos_sp=superpos_scanpath( img,scanpath,10,40,[ 0 1 0;1 0 0; 1 0 0; 0 0 0] );
           imwrite(superpos_sp,['figs' '/' 'scanpaths' '/' model_names{m} '_' imgname '.png']);
           end
    end
end

