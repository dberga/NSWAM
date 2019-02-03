function [  ] = plot_qualitative( dataset_name , model_names)
if nargin<1, dataset_name='tsotsos'; end
if nargin<2, 
model_names={'dmaps','IttiKochNiebur','AIM','abs_no_cortical_config_b1_15_sqmean_fusion2_invdefault','SWAM','no_cortical_config_b1_15_sqmean_fusion2_invdefault','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault_cm1','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault_cm2','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault_cm5','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'};
 end
images_folder=['/media/dberga/DATA/repos/metrics_saliency/input/images/' dataset_name];
smaps_folder=['/media/dberga/DATA/repos/metrics_saliency/input/smaps/' dataset_name '_original_reserva'];

% mkdir(['figs' '/' 'qualitative' '/' dataset_name]);
% 
% images_list=listpath(images_folder);
% 
% for i=1:length(images_list)
%     img_path=[images_folder '/' images_list{i}];
%     [imgfolder,imgname,imgext]=fileparts(img_path);
%    img=double(imread(img_path))./255; 
%    subplot(1,length(model_names)+1,1), imagesc(img);
%    for m=1:length(model_names)
%        smap=double(imread([smaps_folder '/' model_names{m} '/' imgname '.png']))./255; 
%        subplot(1,length(model_names)+1,1+m), imagesc(smap); colormap(jet);
%    end
%    set(gcf,'units','points','position',[10,10,1400,80]);
%    
%    saveas2(gcf,['figs' '/' 'qualitative' '/' dataset_name '/' imgname '.png']);
%    close all;
% end



switch dataset_name
    case 'tsotsos'
        images_list={'27.jpg','30.jpg','72.jpg','77.jpg','94.jpg','105.jpg'};
    case 'sid4vam'
        images_list={'d1Bfv1BdefaultB15.png','d1Bfv5BproximityGdissimilarB5p8333.png','d2Bvs1BfeatureB34.png','d1Bvs6BdefaultB5.png','d2Bvs9BlinearB30.png','d1Bvs5BwTGhBB0p83333.png','d1Bvs5BwTGbBB0p83333.png','d1Bvs4BrTGwBB1.png','d1Bvs4BbTGwBB1.png'};
    case 'kootstra'
        images_list={'nature_37.png','nature_46.png','nature_03.png','nature_49.png','nature_16.png','nature_26.png','nature_31.png','nature_42.png','nature_18.png'};
    case 'cat2000_nopad'
        images_list={'003.png','009.png','043.png','051.png','157.png'};
    otherwise
        images_list=listpath(images_folder);
end

for i=1:length(images_list)
    img_path=[images_folder '/' images_list{i}];
    [imgfolder,imgname,imgext]=fileparts(img_path);
   img=double(imread(img_path))./255; 
   mkdir(['figs' '/' 'qualitative' '/' dataset_name '/images/']);
   imwrite(im2uint8(imresize(img,0.25)),['figs' '/' 'qualitative' '/' dataset_name  '/images/' imgname '.jpg']);
   for m=1:length(model_names)
       mkdir(['figs' '/' 'qualitative' '/' dataset_name '/' model_names{m} '/']);
       smap=double(imread([smaps_folder '/' model_names{m} '/' imgname '.png']))./255; 
       imwrite(im2uint8(imresize(smap,0.25)),jet(256),['figs' '/' 'qualitative' '/' dataset_name  '/' model_names{m} '/' imgname '.jpg']);
   end
   
   close all;
end

end

