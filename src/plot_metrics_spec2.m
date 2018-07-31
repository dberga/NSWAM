
function [  ] = plot_metrics_spec( smaps_path , model_name, list_path)
if nargin < 1, smaps_path='/home/dberga/repos/matlab/output_sid4vam'; end
if nargin < 2, model_name='no_cortical_config_b1_15'; end
if nargin < 3, list_path='/home/dberga/repos/datasets/SID4VAM/sid4vam_rawdata/list.csv'; end

images_path='/home/dberga/repos/matlab/input_sid4vam';

N=230;



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
            image_path=[images_path '/' image_name_noext '.png'];
            smap_path=[smaps_path '/' model_name '/' image_name_noext '.png'];
            dmap_path=[smaps_path '/' 'dmaps' '/' image_name_noext '.png'];
            bmap_path=[smaps_path '/' 'bmaps' '/' image_name_noext '.png'];
            mmap_path=[smaps_path '/' 'mmaps' '/' image_name_noext '.png'];
            
            img=normalize_minmax(im2double(imread(image_path)));
            smap=normalize_minmax(im2double(imread(smap_path)));
            dmap=normalize_minmax(im2double(imread(dmap_path)));
            bmap=clean_bmap(normalize_minmax(im2double(imread(bmap_path))),0.9);
            mask=normalize_minmax(im2double(imread(mmap_path)));
            
            Cw=SIndex(smap,mask);
            Cw_gt=SIndex(dmap,mask);
            sindexes=[sindexes,Cw];
            sindexes_gt=[sindexes_gt,Cw_gt];
            %[~,image_name_noext,ext]=fileparts(images_names{i});

        end
        bar([sindexes_gt',sindexes']);
    end
end

end

