function [ ] = plot_scanpaths_several(img_path, model_names , dataset_out_path  )
    if nargin <1, img_path=['input/111.png']; end
%     if nargin <2, model_names={'no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay25_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay5_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay75_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay999_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay99_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay9_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; end
%     if nargin <2, model_names={'no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay99_s2_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay99_s4_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay99_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; end
%     if nargin<2, model_names={'no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay99_s2_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay99_s4_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay99_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; end
    if nargin<2, model_names={'CLE','LeMeur','LeMeur_faces','LeMeur_landscapes','STAR-FC','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; end
    model_names_alt={'GT','CLE','LeMeur_N','LeMeur_F','LeMeur_L','STAR-FC','NSWAM-CM'};
% model_names_alt={'GT','NSWAM-CM','CLE','LeMeur_N','LeMeur_F','LeMeur_L','STAR-FC'};
    if nargin <3, dataset_out_path='/home/dberga/repos/metrics_saliency/input/smaps/tsotsos_original_reserva'; end
    [imgfolder,imgname,imgext]=fileparts(img_path);
    [~,dataset_name,~]=fileparts(dataset_out_path);
    img=double(imread(img_path))./255;
    
    colors_models{1}=[0 0 0;0 0 0; 0 0 0; 0 0 0; 1 1 1];
    colors_models{2}=[ .31 .59 .80;.31 .59 .80;.31 .59 .80; .31 .59 .80; 0 0 0 ];
    colors_models{3}=[1 0 1;1 0 1; 1 0 1; 1 0 1; 0 0 0 ];
    colors_models{4}=[.58 0 .83;.58 0 .83; .58 0 .83; .58 0 .83; 0 0 0 ];
    colors_models{5}=[.83 0 .83;.83 0 .83;.83 0 .83; .83 0 .83; 0 0 0 ];
    colors_models{6}=[0 1 1;0 1 1;0 1 1; 0 1 1; 0 0 0 ];
    colors_models{7}=[1 0 0;1 0 0; 1 0 0; 1 0 0; 0 0 0 ];
    
%     colors_models{2}=[1 0 0;1 0 0; 1 0 0; 1 0 0; 0 0 0 ];
    
    %GT scanpaths
    gt_scanpaths_path=[dataset_out_path '/' 'dmaps' '/scanpath/' imgname '.mat'];
    load(gt_scanpaths_path);
    scanpath_gt=scanpath;
    for pp=1:length(scanpath)
         scanpath_pp=scanpath{pp};
         try
%            superpos_sp=superpos_scanpath_several( img,{scanpath_pp},5,40,{colors_models{1}});
%            imwrite2(superpos_sp,['figs' '/' 'scanpaths' '/' 'pp'  '_' int2str(pp) '_' imgname '.png']);
         end
    end
    
    %model scanpaths
    for m=1:length(model_names)
           scanpath_path=[dataset_out_path '/' model_names{m} '/scanpath/' imgname '.mat'];
           load(scanpath_path);
           scanpaths{m+1}=scanpath;
           model_samplitude_diff(m)=pp_samplitude_diff(scanpath_gt,scanpath);
           model_samplitude(m)=samplitude(scanpath);
           model_slanding(m)=pp_slanding(scanpath_gt,scanpath);
           try
%             superpos_sp=superpos_scanpath( img,scanpath,10,40,[ 0 1 0;1 0 0; 1 0 0; 0 0 0] );
%             imwrite2(superpos_sp,['figs' '/' 'scanpaths' '/' model_names{m} '_' imgname '.png']);
           end
           
           
    end
    
    mkdir(['figs' '/scanpaths/' dataset_name ]);
    for pp=1:length(scanpath_gt)
         scanpaths{1}=scanpath_gt{pp};
         %vislimit=size(scanpaths{1},1);
         vislimit=5;
         superpos_sp=superpos_scanpath_several( img,scanpaths,vislimit,40, colors_models);
         imwrite2(superpos_sp,['figs' '/scanpaths/' dataset_name '/'  imgname '_pp' num2str(pp) '.png'],1);
    end
    
end

