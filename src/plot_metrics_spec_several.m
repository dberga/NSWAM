
function [  ] = plot_metrics_spec( SIndex_csv_path , model_name, list_path)

if nargin < 1, SIndex_csv_path='/home/dberga/repos/metrics_saliency/output/sid4vam_results_all_SIndex.csv'; end
if nargin < 2, model_names={'IttiKochNiebur','AIM','SWAM','no_cortical_config_b1_15_sqmean_fusion2_invdefault'}; end
if nargin < 3, list_path='/home/dberga/repos/datasets/SID4VAM/sid4vam_rawdata/list.csv'; end
Legend={'GT','IKN','AIM','SWAM','NSWAM'};
addpath(genpath('include'));

N=230;
sindex_cell=r_csv(SIndex_csv_path,repmat('%s',1,N+1));

%get our model row
row_models=1;
row_gt=1;
for mo=1:length(model_names)
    model_name=model_names{mo};
    for row=1:size(sindex_cell,1)
        if strcmp(model_name,sindex_cell{row,1})
           row_models(mo)=row; 
        end
        if strcmp('dmaps',sindex_cell{row,1})
           row_gt=row; 
        end
    end
end

list=r_csv(list_path,repmat('%s',1,N));
list_files={list{2,:}};
contrast_list=cell2mat({list{5,:}});
stim_values=cell2mat({list{6,:}});
stim_values_mult=[cell2mat({list{6,:}});cell2mat({list{7,:}});cell2mat({list{8,:}});cell2mat({list{9,:}})];

blocks={'fv1','fv2','fv3','fv4','fv5','vs1','vs2','vs3','vs4','vs5','vs6','vs7','vs8','vs9','vs10'};
tasktype={'fv','fv','fv','fv','fv','vs','vs','vs','vs','vs','vs','vs','vs','vs','vs'};
blocks_cond={{''},{'single','superimposed'},{''},{''},{'dissimilar','similar'},{'feature','conjunctive','feature-absent','conjunctive-absent'},{'presence','absence'},{'RMS=0.9','RMS=1.1'},{'Red Target & Grey Background','Red Target & Red Background','Blue Target & Grey Background','Blue Target & Red Background'},{'Black Target & White Background','White Target & Black Background'},{''},{''},{'homogeneous','tilted-right','flanking'},{'linear','nonlinear at 10º','nonlinear at 20º','nonlinear at 90º'},{'steep','steepest','steep-right'}};
block_list_str={list{3,:}};
block_cond_list_str={list{4,:}};
block_cond_list= blockcondstr2blockcond( block_cond_list_str,  blocks_cond);
block_list= blockstr2block( block_list_str,  blocks);
blocks_labels={{'Corner Angle (º)','Corner Height (deg)'},{'First Segment Angle Contrast, \Delta\Phi (º)','Second Segment Angle Contrast,  \Delta\Phi (º)' }, {'Segment Spacing (deg)','Bar length (deg)'},{'Contour Length (deg)'}, {'Group Distance (deg)'},{'Set Size (#)'}, {'Scale (deg)','Set Size (#)'},{'Roughness (\beta)'}, {'Saturation Contrast, \DeltaS(HSL)','theta, \theta (º)'}, {'Lightness Contrast, \DeltaL(HSL)'}, {'Size (deg)','Scaling Factor'}, {'Orientation Contrast, \Delta\Phi (º)'}, {'Orientation Contrast to 1st conf, \Delta\Phi (º)','Orientation Contrast to 2st conf,homogeneous, \Delta\Phi (º)','Orientation Contrast to 2st conf,tilted-right, \Delta\Phi (º)','Orientation Contrast to 2st conf,flanking, \Delta\Phi (º)'}, {'Orientation Contrast, \Delta\Phi (º)'}, {'Orientation Contrast to 1st conf, \Delta\Phi (º)','Orientation Contrast to 2st conf, \Delta\Phi (º)'}};
blocks_names={'Corner Salience','Visual Segmentation - Angle','Visual Segmentation - Spacing','Contour Integration','Perceptual Grouping','Feature Search','Search Asymmetries','Rough Surface','Color Contrast','Brightness Contrast','Size Contrast','Angle Contrast','Heterogeneity','Linearity','Categorization'};


blocks_wanted=[7]; for b=1:length(blocks_wanted), b=blocks_wanted(b); %for b=1:length(blocks)
    disp(blocks{b});
    for bc=1:max(block_cond_list(block_list==b))
        disp(blocks_cond{b}{bc});
        corder=contrast_list(block_list==b & block_cond_list==bc);
        fileslist={list_files{block_list==b & block_cond_list==bc}};
        
        sindexes=NaN.*ones(length(model_names),max(corder));
        sindexes_gt=NaN.*ones(1,max(corder));
        for mo=1:length(model_names)
            for i=1:length(fileslist)
                image_name_noext=fileslist{i};
                %[~,image_name_noext,ext]=fileparts(images_names{i});
                for col=1:size(sindex_cell,2)
                    if strcmp(sindex_cell{1,col},image_name_noext)
                        sindexes(mo,contrast_list(i))=sindex_cell{row_models(mo),col};
                        sindexes_gt(contrast_list(i))=sindex_cell{row_gt,col};
                    end
                end
            end
        end
        
        y=[sindexes_gt',sindexes'];
        x=round(stim_values(:,block_list==b & block_cond_list==1),2); 
        if x(1)>x(end), x=fliplr(x); y=fliplr(y); end
        
        %[rho,pval] =corr(y(:,1),y(:,5)) %gt vs nswam
        %[rho,pval] =corr(x',y(:,1)) %x vs gt
        [rho,pval] =corr(x',y(:,5)) %x vs nswam
        %%h=plot(x,y);
        slopes=x'\y;
        regression=x'*slopes;
        
%         x=round(stim_values_mult(2,block_list==b & block_cond_list==1),2); 
%         if x(1)>x(end), x=fliplr(x); y=fliplr(y); end
%         
%         %[rho,pval] =corr(y(:,1),y(:,5)) %gt vs nswam
%         %[rho,pval] =corr(x',y(:,1)) %x vs gt
%         [rho,pval] =corr(x',y(:,5)) %x vs nswam
%         %%h=plot(x,y);
%         slopes=x'\y;
%         regression=x'*slopes;
        
        
        h=bar(x,y);
        title([blocks_names{b} ': ' blocks_cond{b}{bc}]);
        xticks(x);
        xlabel(blocks_labels{b}{1});
        ylabel('Saliency Index');
        ylim([0.2 1]);
        legend(Legend); 
        %h(1).FaceColor=[0 0 0]
        set(gcf,'units','points','position',[10,10,500,200]);
        %savefig(['figs/results_several_' 'b' num2str(b) '_bc' num2str(bc) '.fig']);
        %fig2png(['figs/results_several_' 'b' num2str(b) '_bc' num2str(bc) '.fig'],['figs/results_several_' 'b' num2str(b) '_bc' num2str(bc) '.png']);
        
        
    end
end

end

