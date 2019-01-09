function [  ] = plot_relevance( image_path, mask_path, relevance_paths, metric_results_path )

[image_folder,image_name,image_format]=fileparts(image_path);
img=im2double(imread(image_path));
mask=im2double(imread(mask_path));
for r=1:length(relevance_paths)
   relevance{r}=im2double(imread([relevance_paths{r} '/' image_name '.png']));
   [~,relevance_names{r},~]=fileparts(relevance_paths{r});
end
relevance_names_alt{1}='Fixation Maps';
relevance_names_alt{2}='NSWAM';
relevance_names_alt{3}='NSWAM+TD';
metric_num=2;
metric_num2=12;

% results=r_csv(metric_results_path);
% for m=1:size(results,1)
%     model_name=results{m,1};
%     for r=1:length(relevance_names)
%         if strcmp(model_name,relevance_names{r})
%             indexes(r)=m;
%         end
%     end
% end
% 
% metric_res=[];
% for col=1:size(results,2)
%     if strcmp(image_name,num2str(results{1,col}))
%         for i=1:length(indexes)
%             metric_res=[metric_res,results{indexes(i),col}];
%         end
%     end
% end

for r=1:length(relevance_names)
    load([metric_results_path '/' relevance_names{r} '/' 'results.mat']);
    metric_res(r)=results_struct.metrics{metric_num}.score_all(str2num(image_name));
    metric_res2(r)=results_struct.metrics{metric_num2}.score_all(str2num(image_name));
end

    
subplot(1,2+length(relevance_paths)+2,1),imagesc(img); title(['Image']);axis off;
set(gcf, 'Position',  [100, 100, 1300, 125]);
subplot(1,2+length(relevance_paths)+2,2),imagesc(mask); title(['Mask']);axis off;
for r=1:length(relevance_paths)
    subplot(1,2+length(relevance_paths)+2,2+r),imagesc(relevance{r}); title([relevance_names_alt{r} '(' char( r + 64) ')' ]);axis off;
end
subplot(1,2+length(relevance_paths)+2,2+r+1), bar(metric_res); ylabel('AUC_{Borji}');
for r=1:length(relevance_paths)
    labels{r}=char(r + 64);
end
xticklabels(labels);
ylim([min(metric_res)-0.1,max(metric_res)+0.1]);
if min(metric_res)-0.1 < 0, ylim([0,max(metric_res)+0.1]); end
subplot(1,2+length(relevance_paths)+2,2+r+2), bar(metric_res2); ylabel('Saliency Index');
for r=1:length(relevance_paths)
    labels{r}=char(r + 64);
end
xticklabels(labels);
ylim([min(metric_res2(2:end))-0.0005,max(metric_res2)+0.0005]);
%if min(metric_res2)-0.0005 < 0, ylim([0,max(metric_res2)+0.0005]); end
%if max(metric_res2)>10*max(metric_res2(2:end)), ylim([min(metric_res2(2:end))-0.0005,max(metric_res2(2:end))+0.0005]); end
set(gcf, 'Position',  [100, 100, 1300, 125])
%pause;

end

%plot_relevance('Original Image Set/4.jpg', 'gt_sod_mascaras/4.png',{'no_cortical_config_b1_15_sqmean_fusion2_invdefault','topdown_single_config_b1_15_fusion2'},'tsotsos_results_all_SIndex.csv')

% output_folder='output_relevance'; mkdir(output_folder);
% for i=17:230
%    plot_relevance(['Original Image Set/' num2str(i) '.jpg'], ['gt_sod_mascaras/' num2str(i) '.png'],{'no_cortical_config_b1_15_sqmean_fusion2_invdefault','topdown_single_config_b1_15_fusion2'},'tsotsos_results_all_SIndex.csv')
%    savefig([output_folder '/' num2str(i) '.fig']);
%    fig2png([output_folder '/' num2str(i) '.fig'],[num2str(i) '.png']);
%    close all;
% end


