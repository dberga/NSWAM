function [] = plot_qualitative_topdown( dataset_name , model_names ,metric_eval, metrics_output_path)

if nargin<1, dataset_name='tsotsos'; end
if nargin<2, 
    model_names={'dmaps','no_cortical_config_b1_15_sqmean_fusion2_invdefault','topdown_single_config_b1_15_fusion2'};
    %model_names={'dmaps','no_cortical_config_b1_15_sqmean_fusion2_invdefault','max_topdown_single_config_b1_15_fusion2'};
end
model_names_alt={'GT','NSWAM','NSWAM+VS_C'}; %'NSWAM+VS_M'
model_colors={[0 0 0],[0 1 0],[0 1 1]};

if nargin<3,metric_eval=12; end
if nargin<4, metrics_output_path='/media/dberga/DATA/repos/metrics_saliency/output'; end
images_folder=['/media/dberga/DATA/repos/metrics_saliency/input/images/' dataset_name];
smaps_folder=['/media/dberga/DATA/repos/metrics_saliency/input/smaps/' dataset_name ]; %'_original_reserva'
masks_folder=['/media/dberga/DATA/repos/metrics_saliency/input/mmaps/' dataset_name];

images_list_total=listpath(images_folder);
images_list=images_list_total;
switch dataset_name
    case 'tsotsos'
        images_list={'5.jpg','22.jpg','27.jpg','35.jpg','47.jpg','104.jpg'};
    case 'sid4vam'
        %images_list={'d1Bfv1BdefaultB15.png','d1Bfv5BproximityGdissimilarB5p8333.png','d2Bvs1BfeatureB34.png','d1Bvs6BdefaultB5.png','d2Bvs9BlinearB30.png','d1Bvs5BwTGhBB0p83333.png','d1Bvs5BwTGbBB0p83333.png','d1Bvs4BrTGwBB1.png','d1Bvs4BbTGwBB1.png'};
    otherwise
        images_list=images_list_total;
end

%as in metrics results order
images_list=sort_nat(images_list);
images_list_total=sort_nat(images_list);
image_names={};
for i=1:length(images_list)
        img_path=[images_folder '/' images_list{i}];
        [imgfolder,imgname,imgext]=fileparts(img_path);
        image_names{i}=imgname;
end

correspondence_list=[];
for i=1:length(images_list)
    for j=1:length(images_list_total)
        if strcmp(images_list{i},images_list_total{j})
            correspondence_list(i)=j;
        end
    end
end

results=zeros(length(model_names),1);
for m=1:length(model_names)
    try
    load([metrics_output_path '/' dataset_name '/' model_names{m} '/' 'results.mat']);
    %sAUC
    results(m)=results_struct.metrics{metric_eval}.score;
    
    for i=1:length(images_list_total)
        img_path=[images_folder '/' images_list{i}];
        [imgfolder,imgname,imgext]=fileparts(img_path);
        results_perimage(m,i)=results_struct.metrics{metric_eval}.score_all(i);
    end
    results_perimage_specific(m,1:length(images_list))=results_perimage(m,correspondence_list(1:length(images_list)));
    
    end
end
metric_name=results_struct.metrics{metric_eval}.name;
cell_results=[model_names_alt;num2cell(results')]';
w_csv(cell_results,['figs/topdown/' dataset_name '_' metric_name '.csv']);

for i=1:length(images_list)
    close all;
    h=coloredbar(results_perimage_specific(2:end,i),{model_names_alt{1,2:end}},{model_colors{1,2:end}});
    %lgd=legend(model_names_alt); lgd.Position=[0.505 .53 .475 .45]; lgd.FontSize=6;
    %xticks([]);
    ylim([0 1.5*0.001]); %ylim([0 max(results_perimage_specific(2:end,i))+0.0001]);
    set(gca,'XTickLabelRotation',0);
    set(gca,'FontSize',8);
    set(gcf, 'Position',  [10, 10, 250, 150]);
    ylabel('Saliency Index');
    saveas2(gcf,['figs' '/' 'topdown' '/' dataset_name '/' metric_name '_' image_names{i} '.png']);
end


for i=1:length(images_list)
        img_path=[images_folder '/' images_list{i}];
        [imgfolder,imgname,imgext]=fileparts(img_path);
        mask_path=[masks_folder '/' imgname '.png'];
        img=double(imread(img_path))./255; 
        mask=double(imread(mask_path))./255; 
        mkdir(['figs' '/' 'topdown' '/' dataset_name '/images/']);
        imwrite(im2uint8(imresize(img,0.25)),['figs' '/' 'topdown' '/' dataset_name  '/images/' imgname '.jpg']);
        mkdir(['figs' '/' 'topdown' '/' dataset_name '/masks/']);
        imwrite(im2uint8(imresize(mask,0.25)),jet(256),['figs' '/' 'topdown' '/' dataset_name  '/masks/' imgname '.jpg']);
        for m=1:length(model_names)
           mkdir(['figs' '/' 'topdown' '/' dataset_name '/' model_names{m} '/']);
           smap=double(imread([smaps_folder '/' model_names{m} '/' imgname '.png']))./255; 
           imwrite(im2uint8(imresize(smap,0.25)),jet(256),['figs' '/' 'topdown' '/' dataset_name  '/' model_names{m} '/' imgname '.jpg']);
        end
       close all;
end





end

