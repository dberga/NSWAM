function [ ] = plot_metrics_generic( dataset_name, metric_eval, metrics_output_path , model_names, list_path)

if nargin<5, list_path='/home/dberga/repos/datasets/SID4VAM/sid4vam_rawdata/list.csv'; end
if nargin<4, 
%     model_names={'dmaps','IttiKochNiebur','AIM','no_cortical_config_b1_15_sqmean_fusion2_invdefault','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; %'max_topdown_single_config_b1_15_fusion2',topdown_single_config_b1_15_fusion2
%     model_names_alt={'GT','IKN','AIM','NSWAM','NSWAM-CM'}; %else, model_names_alt=model_names; end %'NSWAM-VS_M','NSWAM-VS_C'
    model_names={'no_cortical_config_b1_15_sqmean_fusion2_invdefault','max_s5_topdown_single_config_b1_15_fusion2','topdown_single_config_b1_15_fusion2'};
    model_names_alt={'NSWAM','NSWAM+VS_M','NSWAM+VS_C'};
else, 
    model_names_alt=model_names; 
end
if nargin<3, metrics_output_path='/media/dberga/DATA/repos/metrics_saliency/output'; end
if nargin<2, metric_eval=11; end %10=sAUC
if nargin<1, dataset_name='sid4vam'; end %dataset_name='tmp/cat2000_nopad';

N=230;
PSI=7; 
blocks_selected=[7]; %select blocks to plot (1:15 for all), %7,9,10,11,12,14

% colors=[0 0 0;  0 0 1; 1 .75 0; 0 1 0; 1 0 0; .31 .86 .39; .5 .73 0];
colors=[0 1 0; 0 .7 0; 0 .5 0];
for c=1:size(colors,1)
   colors_cell{c}=[colors(c,:)]; 
end



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
metric_name=strrep(metric_name,'IG-baseline','InfoGain');
metric_name=strrep(metric_name,'SaccadeLanding','\DeltaSL Error (deg)');
metric_name=strrep(metric_name,'SaccadeAmplitudeDiff','\DeltaSA Error (deg)');
metric_name=strrep(metric_name,'SaccadeAmplitude','SA (deg)');
metric_name=strrep(metric_name,'finside','Prob. Fix. Inside');
metric_name=strrep(metric_name,'SIndex','Saliency Index');
mkdir(['figs/' 'psi' '/']);


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


%round some values
stim_values(:,block_list==2)=[0 10 20 30 42 56 90,0 10 20 30 42 56 90];
stim_values(:,block_list==14)=[0 10 20 30 42 56 90,0 10 20 30 42 56 90,0 10 20 30 42 56 90,0 10 20 30 42 56 90];
% stim_values(:,block_list==7)=stim_values_mult(2,block_list==7);
% blocks_labels{7}{1}='Set Size';

blocks_names{1}='Corner Salience';
blocks_names{2}='Segment. Angle';
blocks_names{3}='Segment. Spacing';
blocks_names{4}='Contour Int.';
blocks_names{5}='Perc. Grouping';

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


%% bar plot for metric for all

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
xlabel('\leftarrow Feature Contrast (\Psi)\rightarrow');
ylabel(metric_name);
set(gcf,'units','points','position',[10,10,350,150]);
xticks(1:PSI);
lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .12];

switch metric_eval
    case 10
        ylim([.4 1]);
    case 11
        ylim([-.5 .5]);
    otherwise
        ylim([min(results_psi(:))-nanstd(results_psi(:)) max(results_psi(:))+nanstd(results_psi(:))]);
end
    
saveas2(gcf,['figs/' 'quantitative' '/' 'psi_all_' dataset_name '_' metric_name '.png']);

%% bar plot metric per block

for b=1:length(blocks) %%fv,vs
    for m=1:size(results_perstimulus,1) %model name
        results_perblock_all(m,b)=nanmean(results_perstimulus(m,block_list==b));
        results_perblock_all_std(m,b)=nanstd(results_perstimulus(m,block_list==b));
    end
end

close all;
h=bar(results_perblock_all');
for hi=1:length(h)
h(hi).FaceColor=colors(hi,:);
end
ylabel(metric_name);
xlabel('Feature Type');
xtickangle(45);
xticklabels(blocks_names);
xAX=get(gca,'XAxis');
set(xAX,'FontSize', 8);
lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .12];
saveas2(gcf,['figs/' 'quantitative' '/' 'lowlevelfeatures_' dataset_name '_' metric_name '.png']);

close all;
h=bar(results_perblock_all(:,1:5)');
for hi=1:length(h)
h(hi).FaceColor=colors(hi,:);
end
ylabel(metric_name);
% xlabel('Feature Type');
xtickangle(45);
xticklabels(blocks_names(:,1:5));
xAX=get(gca,'XAxis');
set(xAX,'FontSize', 8);
% lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .12];
saveas2(gcf,['figs/' 'quantitative' '/' 'lowlevelfeatures_fv_' dataset_name '_' metric_name '.png']);


close all;
h=bar(results_perblock_all(:,6:15)');
for hi=1:length(h)
h(hi).FaceColor=colors(hi,:);
end
ylabel(metric_name);
% xlabel('Feature Type');
xtickangle(45);
xticklabels(blocks_names(:,6:15));
xAX=get(gca,'XAxis');
set(xAX,'FontSize', 8);
% lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .12];
ylim([-0.0005 0.004])
xlim([0 11])
saveas2(gcf,['figs/' 'quantitative' '/' 'lowlevelfeatures_vs_' dataset_name '_' metric_name '.png']);


%% bar plot metric per task
T=max(tasktypes(:));
for t=1:T %%fv,vs
    results_psi_pertask{t}=NaN.*ones(size(results_perstimulus,1),PSI);
    results_psi_pertask_std{t}=NaN.*ones(size(results_perstimulus,1),PSI);
    results_all_pertask{t}=NaN.*ones(1,size(results_perstimulus,1));
    results_all_pertask_std{t}=NaN.*ones(1,size(results_perstimulus,1));
    for m=1:size(results_perstimulus,1) %model name
        for psi=1:PSI
            results_psi_pertask{t}(m,psi)=nanmean(results_perstimulus(m,tasktypes==t & contrast_list==psi));
            results_psi_pertask_std{t}(m,psi)=nanstd(results_perstimulus(m,tasktypes==t & contrast_list==psi));
        end
        results_all_pertask{t}(m)=nanmean(results_perstimulus(m,tasktypes==t));
        results_all_pertask_std{t}(m)=nanstd(results_perstimulus(m,tasktypes==t));
    end
end

for t=1:T
    h=bar(results_psi_pertask{t}');
    for hi=1:length(h)
    h(hi).FaceColor=colors(hi,:);
    end
    xlabel('\leftarrow Feature Contrast (\Psi)\rightarrow');
    ylabel(metric_name);
    set(gcf,'units','points','position',[10,10,350,150]);
    xticks(1:PSI);
    lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .12];
    title(task_names{t});
    switch metric_eval
        case 10
            ylim([.4 1]);
        case 11
            ylim([-.5 .5]);
        otherwise
            ylim([min(results_psi_pertask{t}(:))-nanstd(results_psi_pertask{t}(:)) max(results_psi_pertask{t}(:))+nanstd(results_psi_pertask{t}(:))]);
    end
    saveas2(gcf,['figs/' 'quantitative' '/' 'psi_t' num2str(t) '_' dataset_name '_' metric_name '.png']);
end


%model differences in fv and vs

nanmean(results_perstimulus(2,tasktypes==1))-nanmean(results_perstimulus(1,tasktypes==1))
nanmean(results_perstimulus(3,tasktypes==1))-nanmean(results_perstimulus(1,tasktypes==1))

nanmean(results_perstimulus(2,tasktypes==2))-nanmean(results_perstimulus(1,tasktypes==2))
nanmean(results_perstimulus(3,tasktypes==2))-nanmean(results_perstimulus(1,tasktypes==2))


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
for bb=1:length(blocks_selected)
    close all;
    b=blocks_selected(bb)
    xvalues=1:PSI; %original
    xvalues=stim_values(:,block_list==b & block_cond_list==1);
    yvalues=results_psi_perblock{b}';
    if xvalues(1)>xvalues(end), xvalues=fliplr(xvalues); yvalues=flipud(yvalues); end
    if ismember(b,[12,13,14,15]), xvalues=round(xvalues); end
    if ismember(b,[4]),yvalues(end,:)=[]; end
    h=bar(xvalues,yvalues);
    xticks(xvalues);
    for hi=1:length(h)
    h(hi).FaceColor=colors(hi,:);
    end
%     xlabel('\leftarrow Feature Contrast (\Psi)\rightarrow');
    xlabel(blocks_labels{b}{1});
    ylabel(metric_name);
    set(gcf,'units','points','position',[10,10,350,150]);
%     lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .12];
    %title(blocks_names{b});
    switch metric_eval
    case 10
        ylim([.4 1]);
    case 11
        ylim([-.5 .5]);
    otherwise
        if sum(results_psi_perblock{b}(:)>0)
        ylim([min(results_psi_perblock{b}(:))-nanstd(results_psi_perblock{b}(:)) max(results_psi_perblock{b}(:))+nanstd(results_psi_perblock{b}(:))]);
        end
    end
    saveas2(gcf,['figs/' 'quantitative' '/' 'psi_b' num2str(b) '_' dataset_name '_' metric_name '.png']);
end

%% bar plot metric per subblock

%get values
for b=1:length(blocks)
    for bc=1:length(blocks_cond{b})
        results_psi_persubblock{b}{bc}=NaN.*ones(size(results_perstimulus,1),PSI);
        results_psi_persubblock_std{b}{bc}=NaN.*ones(size(results_perstimulus,1),PSI);
        for m=1:size(results_perstimulus,1) %model name
            for psi=1:PSI
                results_psi_persubblock{b}{bc}(m,psi)=nanmean(results_perstimulus(m,block_list==b & contrast_list==psi & block_cond_list==bc));
                results_psi_persubblock_std{b}{bc}(m,psi)=nanstd(results_perstimulus(m,block_list==b & contrast_list==psi & block_cond_list==bc));
            end
        end
    end
end

%plot
for bb=1:length(blocks_selected)
    close all;
    b=blocks_selected(bb)
    if length(blocks_cond{b})>1
        for bc=1:length(blocks_cond{b})
            b,bc
            xvalues=1:PSI; %original
            xvalues=stim_values(:,block_list==b & block_cond_list==bc);
            yvalues=results_psi_persubblock{b}{bc}';
            if xvalues(1)>xvalues(end), xvalues=fliplr(xvalues); yvalues=flipud(yvalues); end
            if ismember(b,[12,13,14,15]), xvalues=round(xvalues); end
            if ismember(b,[4]),yvalues(end,:)=[]; end
%             if ismember(b,[7]),xvalues=fliplr(xvalues);yvalues=fliplr(yvalues); end
            h=bar(xvalues,yvalues);
            xticks(xvalues);
            if ismember(b,[7]),xticklabels(stim_values_mult(2,block_list==7 & block_cond_list==1)); end
            for hi=1:length(h)
            h(hi).FaceColor=colors(hi,:);
            end
        %     xlabel('\leftarrow Feature Contrast (\Psi)\rightarrow');
            xlabel(blocks_labels{b}{1});
            ylabel(metric_name);
            set(gcf,'units','points','position',[10,10,350,150]);
            %lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .12];
            %title([blocks_names{b} ': ' blocks_cond{b}{bc}]);
            switch metric_eval
                case 10
                    ylim([.4 1]);
                case 11
                    ylim([-.5 .5]);
                otherwise
                    if sum(results_psi_persubblock{b}{bc}(:)>0)
                        ylim([min(results_psi_persubblock{b}{bc}(:))-nanstd(results_psi_persubblock{b}{bc}(:)) max(results_psi_persubblock{b}{bc}(:))+nanstd(results_psi_persubblock{b}{bc}(:))]);
                    end
            end
            saveas2(gcf,['figs/' 'quantitative' '/' 'psi_b' num2str(b) '_bc' num2str(bc) '_' dataset_name '_' metric_name '.png']);
        end
    end
end

end

