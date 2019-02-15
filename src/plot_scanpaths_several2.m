function [  ] = plot_scanpaths_several2(img_path, model_names , dataset_out_path  )
    if nargin <1, img_path=['input/111.png']; end
    if nargin <2, model_names={'dmaps','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay25_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay5_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay75_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay999_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay99_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay9_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; end
    %if nargin <2, model_names={'no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay25_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay5_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay75_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay999_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay99_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay9_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; end
    if nargin <3, dataset_out_path='output_tsotsos'; end
    
    [imgfolder,imgname,imgext]=fileparts(img_path);
    img=double(imread(img_path))./255;
    
    mkdir(['figs' '/scanpaths2']);
    for m=1:length(model_names)
           scanpath_path=[dataset_out_path '/' model_names{m} '/scanpath/' imgname '.mat'];
           smaps_folder=[dataset_out_path '/' model_names{m} '/gazes/' ];
           [ scanpath ] = smapsfolder2scanpath( img_path, smaps_folder );
           try
           superpos_sp=superpos_scanpath( img,scanpath,10,40,[ 0 1 0;1 0 0; 1 0 0; 0 0 0] );
           imwrite2(superpos_sp,['figs' '/' 'scanpaths2' '/' model_names{m} '_' imgname '.png']);
           end
    end
end

