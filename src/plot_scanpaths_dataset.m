function [  ] = plot_scanpaths( input_dataset, output_folder, model_name )

if nargin<1, input_dataset='input_tsotsos'; end
% if nargin<2, output_folder='output_tsotsos'; end
if nargin<2, output_folder='/home/dberga/repos/metrics_saliency/input/smaps/tsotsos_original_reserva'; end
% if nargin<3, model_names={'dmaps','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault','ior_decay99_sa_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; end
if nargin<3, model_names={'CLE','LeMeur','LeMeur_faces','LeMeur_landscapes','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; end

files=listpath(input_dataset);



mkdir('figs/scanpaths');
for f=1:length(files)
    [imgfolder,imgname,imgext]=fileparts([input_dataset '/' files{f}]);
    plot_scanpaths_several([input_dataset '/' files{f}],model_names,output_folder);
    
%     img=im2double(imread([input_dataset '/' files{f}]));
%     for m=1:length(models)
%         model_name=model_names{m}; 
%         %if ~exist(['figs' '/' 'scanpaths'  '/' model_name '_' imgname '.png'],'file') &&
%         if exist([output_folder '/' model_name '/' 'scanpath' '/' imgname '.mat'],'file')
%         load([output_folder '/' model_name '/' 'scanpath' '/' imgname '.mat']);
%         scanpaths{m}=scanpath;
%         end
%     end
%     superpos_sp=superpos_scanpath_several( img,scanpaths,10,40 ,colors_models);
%     legend(model_names);
%     imwrite2(superpos_sp,['figs' '/' 'scanpaths' '_' imgname '.png']);
end



end
