
function [  ] = plot_metrics_spec( SIndex_csv_path , model_name, list_path)

if nargin < 1, SIndex_csv_path='/home/dberga/repos/metrics_saliency/output/sid4vam_results_all_AUC_Judd.csv'; end
if nargin < 2, model_name='no_cortical_config_b1_15'; end
if nargin < 3, list_path='/home/dberga/repos/datasets/SID4VAM/sid4vam_rawdata/list.csv'; end

N=230;
sindex_cell=r_csv(SIndex_csv_path,repmat('%s',1,N+1));

%get our model row
row_model=1;
row_gt=1;
for row=1:size(sindex_cell,1)
    if strcmp(model_name,sindex_cell{row,1})
       row_model=row; 
    end
    if strcmp('dmaps',sindex_cell{row,1})
       row_gt=row; 
    end
end

list=r_csv(list_path,repmat('%s',1,N));
list_files={list{2,:}};
contrast_list=cell2mat({list{5,:}});

blocks={'fv1','fv2','fv3','fv4','fv5','vs1','vs2','vs3','vs4','vs5','vs6','vs7','vs8','vs9','vs10'};
tasktype={'fv','fv','fv','fv','fv','vs','vs','vs','vs','vs','vs','vs','vs','vs','vs'};
blocks_cond={{''},{'single','superimposed'},{''},{''},{'dissimilar','similar'},{'feature','conjunctive','feature-absent','conjunctive-absent'},{'presence','absence'},{'RMS=0.9','RMS=1.1'},{'Red Target & Grey Background','Red Target & Red Background','Blue Target & Grey Background','Blue Target & Red Background'},{'Black Target & White Background','White Target & Black Background'},{''},{''},{'homogeneous','tilted-right','flanking'},{'linear','nonlinear at 10º','nonlinear at 20º','nonlinear at 90º'},{'steep','steepest','steep-right'}};
block_list_str={list{3,:}};
block_cond_list_str={list{4,:}};
block_cond_list= blockcondstr2blockcond( block_cond_list_str,  blocks_cond);
block_list= blockstr2block( block_list_str,  blocks);

for b=6:length(blocks) %for b=1:length(blocks)
    disp(blocks{b});
    for bc=1:max(block_cond_list(block_list==b))
        disp(blocks_cond{b}{bc});
        corder=contrast_list(block_list==b & block_cond_list==bc);
        fileslist={list_files{block_list==b & block_cond_list==bc}};
        
        sindexes=[];
        sindexes_gt=[];

        for i=1:length(fileslist)
            image_name_noext=fileslist{i};
            %[~,image_name_noext,ext]=fileparts(images_names{i});
            for col=1:size(sindex_cell,2)
                if strcmp(sindex_cell{1,col},image_name_noext)
                    sindexes=[sindexes,sindex_cell{row_model,col}];
                    sindexes_gt=[sindexes_gt,sindex_cell{row_gt,col}];
                end
            end
        end
        bar([sindexes_gt',sindexes']);
    end
end

end

