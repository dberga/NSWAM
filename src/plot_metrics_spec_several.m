
function [  ] = plot_metrics_spec( SIndex_csv_path , model_name, list_path)

if nargin < 1, SIndex_csv_path='/home/dberga/repos/metrics_saliency/output/sid4vam_results_all_SIndex.csv'; end
if nargin < 2, model_names={'IttiKochNiebur','AIM','SWAM','no_cortical_config_b1_15'}; end
if nargin < 3, list_path='/home/dberga/repos/datasets/SID4VAM/sid4vam_rawdata/list.csv'; end

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

blocks={'fv1','fv2','fv3','fv4','fv5','vs1','vs2','vs3','vs4','vs5','vs6','vs7','vs8','vs9','vs10'};
tasktype={'fv','fv','fv','fv','fv','vs','vs','vs','vs','vs','vs','vs','vs','vs','vs'};
blocks_cond={{''},{'single','superimposed'},{''},{''},{'dissimilar','similar'},{'feature','conjunctive','feature-absent','conjunctive-absent'},{'presence','absence'},{'RMS=0.9','RMS=1.1'},{'Red Target & Grey Background','Red Target & Red Background','Blue Target & Grey Background','Blue Target & Red Background'},{'Black Target & White Background','White Target & Black Background'},{''},{''},{'homogeneous','tilted-right','flanking'},{'linear','nonlinear at 10º','nonlinear at 20º','nonlinear at 90º'},{'steep','steepest','steep-right'}};
block_list_str={list{3,:}};
block_cond_list_str={list{4,:}};
block_cond_list= blockcondstr2blockcond( block_cond_list_str,  blocks_cond);
block_list= blockstr2block( block_list_str,  blocks);
blocks_labels={{'Corner Angle (º)','Corner Height (deg)'},{'First Segment Angle Contrast, \Delta\Phi (º)','Second Segment Angle Contrast,  \Delta\Phi (º)' }, {'Segment Spacing (deg)','Bar length (deg)'},{'Contour Length (deg)'}, {'Group Distance (deg)'},{'Set Size (#)'}, {'Scale (deg)','Set Size (#)'},{'Roughness (\beta)'}, {'Saturation Contrast, \DeltaS(HSL)','theta, \theta (º)'}, {'Lightness Contrast, \DeltaL(HSL)'}, {'Size (deg)','Scaling Factor'}, {'Orientation Contrast, \Delta\Phi (º)'}, {'Orientation Contrast to 1st conf, \Delta\Phi (º)','Orientation Contrast to 2st conf,homogeneous, \Delta\Phi (º)','Orientation Contrast to 2st conf,tilted-right, \Delta\Phi (º)','Orientation Contrast to 2st conf,flanking, \Delta\Phi (º)'}, {'Orientation Contrast, \Delta\Phi (º)'}, {'Orientation Contrast to 1st conf, \Delta\Phi (º)','Orientation Contrast to 2st conf, \Delta\Phi (º)'}};
blocks_names={'Corner Salience','Visual Segmentation - Angle','Visual Segmentation - Spacing','Contour Integration','Perceptual Grouping','Feature Search','Search Asymmetries','Rough Surface','Color Contrast','Brightness Contrast','Size Contrast','Angle Contrast','Heterogeneity','Linearity','Categorization'};


blocks_wanted=[9,10,11,12]; for b=1:length(blocks_wanted), b=blocks_wanted(b); %for b=1:length(blocks)
    disp(blocks{b});
    for bc=1:max(block_cond_list(block_list==b))
        disp(blocks_cond{b}{bc});
        corder=contrast_list(block_list==b & block_cond_list==bc);
        fileslist={list_files{block_list==b & block_cond_list==bc}};
        
        sindexes=zeros(length(model_names),max(contrast_list));
        sindexes_gt=zeros(1,max(contrast_list));
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
        bar(stim_values(:,block_list==b & block_cond_list==1),[sindexes_gt',sindexes']);
        title([blocks_names{b} '; ' blocks_cond{b}{bc}]);
        xlabel(blocks_labels{b}{1});
    end
end

end

