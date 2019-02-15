function [ ] = plot_metrics_generic( dataset_name, metric_eval, metrics_output_path , model_names, list_path)

if nargin<5, list_path='/home/dberga/repos/datasets/SID4VAM/sid4vam_rawdata/list.csv'; end
if nargin<4, 
    model_names={'dmaps','IttiKochNiebur','AIM','no_cortical_config_b1_15_sqmean_fusion2_invdefault','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'};  %abs_no_cortical_config_b1_15_sqmean_fusion2_invdefault
    model_names_alt={'GT','IKN','AIM','NSWAM','NSWAM-CM'}; else, model_names_alt=model_names; end %SWAM
if nargin<3, metrics_output_path='/media/dberga/DATA/repos/metrics_saliency/output'; end
if nargin<2, metric_eval=10; end %10=sAUC
if nargin<1, dataset_name='sid4vam'; end %dataset_name='tmp/cat2000_nopad';


N=230;
colors=[0 0 0;  0 0 1; 1 .75 0; 0 1 0; 1 0 0];

results_perstimulus=zeros(length(model_names),1);
for m=1:length(model_names)
    try
    load([metrics_output_path '/' dataset_name '/' model_names{m} '/' 'results.mat']);
    for i=1:N
        results_perstimulus(m,i)=results_struct.metrics{metric_eval}.score_all(i);
    end
    end
end

metric_name=results_struct.metrics{metric_eval}.name; 
metric_name=strrep(metric_name,'_','-'); %substrings only for 1 char in matlab
metric_name=strrep(metric_name,'-trials','');
metric_name=strrep(metric_name,'-Borji','');
mkdir(['figs/' 'quantitative' '/']);


%% read image instances for PSI
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

%vigilar amb ordre de la llista. 
%1:230==cell2mat(list(1,:));
%strcmp(filenames_noext_cell,list(2,:)');
    
filenames_cell = dirpath2listpath(dir(['/media/dberga/DATA/repos/metrics_saliency/input/images/'  dataset_name '/' '*.' 'png'])); 
filenames_cell = sort_nat(filenames_cell);
filenames_noext_cell = filenames_cell;
for f=1:length(filenames_cell)
    filenames_noext_cell{f} = remove_extension(filenames_cell{f});
end

% %erase GT for better representation
% results_gazewise(1,:)=[];
% colors(1,:)=[];
% model_names_alt(:,1)=[];

%% bar plot for metric per psi

PSI=7; 
for m=1:size(results_perstimulus,1) %model name
    for psi=1:PSI
        results_psi(m,psi)=results_perstimulus(m,contrast_list==psi);
    end
end


%error: el cas de contour integration (fv4) no hi ha el psi 7 -> replicar el 6e

end

