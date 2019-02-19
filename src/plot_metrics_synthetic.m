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

stim_values=cell2mat({list{6,:}});
stim_values_mult=[cell2mat({list{6,:}});cell2mat({list{7,:}});cell2mat({list{8,:}});cell2mat({list{9,:}})];
blocks_labels={{'Corner Angle (º)','Corner Height (deg)'},{'First Segment Angle Contrast, \Delta\Phi (º)','Second Segment Angle Contrast,  \Delta\Phi (º)' }, {'Segment Spacing (deg)','Bar length (deg)'},{'Contour Length (deg)'}, {'Group Distance (deg)'},{'Set Size (#)'}, {'Scale (deg)','Set Size (#)'},{'Roughness (\beta)'}, {'Saturation Contrast, \DeltaS(HSL)','theta, \theta (º)'}, {'Lightness Contrast, \DeltaL(HSL)'}, {'Size (deg)','Scaling Factor'}, {'Orientation Contrast, \Delta\Phi (º)'}, {'Orientation Contrast to 1st conf, \Delta\Phi (º)','Orientation Contrast to 2st conf,homogeneous, \Delta\Phi (º)','Orientation Contrast to 2st conf,tilted-right, \Delta\Phi (º)','Orientation Contrast to 2st conf,flanking, \Delta\Phi (º)'}, {'Orientation Contrast, \Delta\Phi (º)'}, {'Orientation Contrast to 1st conf, \Delta\Phi (º)','Orientation Contrast to 2st conf, \Delta\Phi (º)'}};
blocks_names={'Corner Salience','Visual Segmentation - Angle','Visual Segmentation - Spacing','Contour Integration','Perceptual Grouping','Feature Search','Search Asymmetries','Rough Surface','Color Contrast','Brightness Contrast','Size Contrast','Angle Contrast','Heterogeneity','Linearity','Categorization'};
blocks_names_alt={'(1)','(2)','(3)','(4)','(5)','(6)','(7)','(8)','(9)','(10)','(11)','(12)','(13)','(14)','(15)'};
blocks_cond={{''},{'single','superimposed'},{''},{''},{'dissimilar','similar'},{'feature','conjunctive','feature-absent','conjunctive-absent'},{'presence','absence'},{'RMS=0.9','RMS=1.1'},{'Red Target & Grey Background','Red Target & Red Background','Blue Target & Grey Background','Blue Target & Red Background'},{'Black Target & White Background','White Target & Black Background'},{''},{''},{'homogeneous','tilted-right','flanking'},{'linear','nonlinear at 10º','nonlinear at 20º','nonlinear at 90º'},{'steep','steepest','steep-right'}};
block_list_str={list{3,:}};
block_cond_list_str={list{4,:}};
block_cond_list= blockcondstr2blockcond( block_cond_list_str,  blocks_cond);
block_list= blockstr2block( block_list_str,  blocks);
tasktype={'fv','fv','fv','fv','fv','vs','vs','vs','vs','vs','vs','vs','vs','vs','vs'};
task_names={'Free-Viewing','Visual Search'};
[tasktypes,difficulties]=get_tasktypes_difficulties(list_files);

    
PSI=7; 

%% read files list
filenames_cell = dirpath2listpath(dir(['/media/dberga/DATA/repos/metrics_saliency/input/images/'  dataset_name '/' '*.' 'png'])); 
filenames_cell = sort_nat(filenames_cell);
filenames_noext_cell = filenames_cell;
for f=1:length(filenames_cell)
    filenames_noext_cell{f} = remove_extension(filenames_cell{f});
end

%% reorder results with our dataset list
%vigilar amb ordre de la llista. -> posar tal i com esta ordenat al dataset
%1:230==cell2mat(list(1,:));
if sum(strcmp(filenames_noext_cell,list(2,:)'))==0
    list_order1=ones(1,N);
    list_order2=ones(1,N);
    for f1=1:length(filenames_noext_cell)
       for f2=1:length(list_files)
           if strcmp(filenames_noext_cell{f1},list_files{f2})
               list_order1(f2)=f1;
               list_order2(f1)=f2;
           end
       end
    end
end
results_perstimulus=results_perstimulus(:,list_order1);

% %erase GT for better representation
% results_gazewise(1,:)=[];
% colors(1,:)=[];
% model_names_alt(:,1)=[];

%% bar plot for metric per psi

%get values
results_psi=NaN.*ones(size(results_perstimulus,1),PSI);
results_psi_std=NaN.*ones(size(results_perstimulus,1),PSI);
for m=1:size(results_perstimulus,1) %model name
    for psi=1:PSI
        results_psi(m,psi)=nanmean(results_perstimulus(m,contrast_list==psi));
        results_psi_std(m,psi)=nanstd(results_perstimulus(m,contrast_list==psi));
    end
end
%vigilar el cas de contour integration (fv4) no hi ha el psi 7 -> replicar el 6e o no utilitzar.


%%% old
% h=plot(1:PSI,results_psi);  xlim([1,PSI]);
% %%h=errorbar(repmat(1:PSI,size(results_psi,1),1)',results_psi',results_psi_std','-o','LineWidth', 2);
% for hi=1:length(h)
% h(hi).LineWidth=3;
% h(hi).Color=colors(hi,:);
% end


%plot
h=bar(results_psi');
for hi=1:length(h)
h(hi).FaceColor=colors(hi,:);
end
xlabel('Feature Contrast (\Psi)');
ylabel(metric_name);
set(gcf,'units','points','position',[10,10,350,150]);
xticks(1:PSI);
lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .12];
saveas2(gcf,['figs/' 'quantitative' '/' 'psi_all_' dataset_name '_' metric_name '.png']);

%% bar plot metric per block

%get values
for b=1:length(blocks)
    results_psi_perblock{b}=NaN.*ones(size(results_perstimulus,1),PSI);
    results_psi_perblock_std{b}=NaN.*ones(size(results_perstimulus,1),PSI);
    for m=1:size(results_perstimulus,1) %model name
        for psi=1:PSI
            results_psi_perblock{b}(m,psi)=nanmean(results_perstimulus(m,block_list==b & contrast_list==psi));
            results_psi_perblock_std{b}(m,psi)=nanstd(results_perstimulus(m,block_list==b & contrast_list==psi));
        end
    end
end

%plot

for b=1:length(blocks)
    h=bar(results_psi_perblock{b}');
    for hi=1:length(h)
    h(hi).FaceColor=colors(hi,:);
    end
    xlabel('Feature Contrast (\Psi)');
    ylabel(metric_name);
    set(gcf,'units','points','position',[10,10,350,150]);
    xticks(1:PSI);
    lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .12];
    title(blocks_names{b});
    saveas2(gcf,['figs/' 'quantitative' '/' 'psi_b' num2str(b) '_' dataset_name '_' metric_name '.png']);
end

%% bar plot metric per task
T=max(tasktypes(:));
for t=1:T %%fv,vs
    results_psi_pertask{t}=NaN.*ones(size(results_perstimulus,1),PSI);
    results_psi_pertask_std{b}=NaN.*ones(size(results_perstimulus,1),PSI);
    for m=1:size(results_perstimulus,1) %model name
        for psi=1:PSI
            results_psi_pertask{t}(m,psi)=nanmean(results_perstimulus(m,tasktypes==t & contrast_list==psi));
            results_psi_pertask_std{t}(m,psi)=nanstd(results_perstimulus(m,tasktypes==t & contrast_list==psi));
        end
    end
end

for t=1:T
    h=bar(results_psi_pertask{t}');
    for hi=1:length(h)
    h(hi).FaceColor=colors(hi,:);
    end
    xlabel('Feature Contrast (\Psi)');
    ylabel(metric_name);
    set(gcf,'units','points','position',[10,10,350,150]);
    xticks(1:PSI);
    lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .12];
    title(task_names{t});
    saveas2(gcf,['figs/' 'quantitative' '/' 'psi_t' num2str(t) '_' dataset_name '_' metric_name '.png']);
end



end

