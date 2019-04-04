function [ ] = plot_metrics_generic( dataset_name, metric_eval, metrics_output_path , model_names)

if nargin<4, 
    %model_names={'dmaps','IttiKochNiebur','AIM','no_cortical_config_b1_15_sqmean_fusion2_invdefault','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'};  %abs_no_cortical_config_b1_15_sqmean_fusion2_invdefault
    %model_names_alt={'GT','IKN','AIM','NSWAM','NSWAM-CM'}; else, model_names_alt=model_names; end %SWAM
    model_names={'dmaps','CLE','LeMeur','LeMeur_faces','LeMeur_landscapes','STAR-FC','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'};
%     model_names={'no_cortical_config_b1_15_sqmean_fusion2_invdefault','max_s5_topdown_single_config_b1_15_fusion2','topdown_single_config_b1_15_fusion2'}; %max_topdown_single_config_b1_15_fusion2
end %SWAM
model_names_alt={'GT','CLE','LeMeur_N','LeMeur_F','LeMeur_L','STAR-FC','NSWAM-CM'};
% model_names_alt={'NSWAM','NSWAM+VS_M','NSWAM+VS_C'};
if nargin<3, metrics_output_path='/media/dberga/DATA/repos/metrics_saliency/output'; end
if nargin<2, metric_eval=17; end %10=sAUC,11=InfoGain,9=PFI,12=SIndex
if nargin<1, dataset_name='tsotsos'; end %dataset_name='tmp/cat2000_nopad';

% colors=[0 0 0;  0 0 1; 1 .75 0; 0 1 0; 1 0 0];
colors=[0 0 0;  .31 .59 .80; 1 0 1; .83 0 .83; .58 0 .83; 0 1 1; 1 0 0];
% colors=[0 1 0; 0 .7 0; 0 .5 0];

for c=1:size(colors,1)
   colors_cell{c}=[colors(c,:)]; 
end

switch dataset_name
    case 'tsotsos'
       pxva=32;
    case 'kootstra'
       pxva=34;
    case 'cat2000_nopad'
       pxva=38;
    case 'sid4vam'
       pxva=40;
end

results=zeros(length(model_names),1);
results_sdev=zeros(length(model_names),1);
results_all=zeros(length(model_names),1);
for m=1:length(model_names)
    try
    load([metrics_output_path '/' dataset_name '/' model_names{m} '/' 'results.mat']);
    %sAUC
    results(m)=results_struct.metrics{metric_eval}.score;
    results_sdev(m)=results_struct.metrics{metric_eval}.sdev;
    results_all(m,1:length(results_struct.metrics{metric_eval}.score_all))=results_struct.metrics{metric_eval}.score_all;
    end
end


if metric_eval>12
results=results./pxva;
results_sdev=results_sdev./pxva;
end

metric_name=results_struct.metrics{metric_eval}.name; 
metric_name_old=results_struct.metrics{metric_eval}.name; 
metric_name=strrep(metric_name,'_','-'); %substrings only for 1 char in matlab
metric_name=strrep(metric_name,'-trials','');
metric_name=strrep(metric_name,'-Borji','');
metric_name=strrep(metric_name,'IG-baseline','InfoGain');
metric_name=strrep(metric_name,'SaccadeLanding','\DeltaSL Error (deg)');
metric_name=strrep(metric_name,'SaccadeAmplitudeDiff','\DeltaSA Error (deg)');
metric_name=strrep(metric_name,'SaccadeAmplitude','SA (deg)');
metric_name=strrep(metric_name,'finside','Prob. Fix. Inside');
metric_name=strrep(metric_name,'SIndex','Saliency Index');
mkdir(['figs/' 'quantitative' '/']);

%% bar plot for metric result
close all;
h=coloredbar(results,model_names_alt,colors_cell);
% h2=errorbar(results,results_sdev,'Color','black','LineStyle','none','LineWidth',2);
%title([]);
% for hi=1:length(h)
% h(hi).FaceColor=colors(hi,:);
% end
xlim([0,4])
xticklabels(model_names_alt);
xtickangle(45);
set(gca,'XTick',[]);
lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.73 .77 .26 .22];
ylabel(metric_name);
%xlabel(blocks_labels{b}{1});
%ylabel(metric_name);
%if max(results(:))>0.2, ylim([0.2 1]); else, ylim([min(ylims), max(ylims)]); end
% ylim([min(results(:))-0.02 max(results(:))+0.02]);
%h(1).FaceColor=[0 0 0];
%set(gcf,'units','points','position',[10,10,500,175]);
set(gcf,'units','points','position',[10,10,262,130]);
saveas(gcf,['figs/' 'quantitative' '/' dataset_name '_' metric_name_old '_static' '.png']);
cell_results=[model_names_alt;num2cell(results');num2cell(results_sdev')]';
w_csv(cell_results,['figs/quantitative/' dataset_name '_' metric_name '.csv']);

%% plot for metric result per gaze
G=10; %fixation num max
results_gazewise=NaN.*ones(length(model_names),G);
for m=1:length(model_names)
    load([metrics_output_path '/' dataset_name '/' model_names{m} '/' 'results.mat']);
    try
        G2=length(results_struct.metrics_gazewise{metric_eval}.score);
        results_gazewise(m,1:G2)=cell2mat(results_struct.metrics_gazewise{metric_eval}.score(1:G2));
    catch
        try
            results_gazewise(m,1:G2)=results_struct.metrics_gazewise{metric_eval}.score(1:G2);
        catch
            G2=20;
            results_gazewise(m,1:G)=NaN.*ones(1,G);
        end
    end
end


%erase GT for better representation
if sum(ismember([13,17],metric_eval))
    results_gazewise(1,:)=[];
    colors(1,:)=[];
    model_names_alt(:,1)=[];
end
%copy static maps to several results
for m=1:size(results_gazewise,1)
    for g=2:size(results_gazewise,2)
        if isnan(results_gazewise(m,g)) && sum(isnan(results_gazewise(m,:)))>0
            results_gazewise(m,g)=results_gazewise(m,g-1);
        end
    end
end


if metric_eval>12
results_gazewise=results_gazewise./pxva;
end
        
close all;
h=plot(1:G,results_gazewise(:,1:G));
xlim([1,G]);
if nansum(results_gazewise(:))
    ylim([min(results_gazewise(:))-0.02 max(results_gazewise(:))+0.02]);
end
for hi=1:length(h)
h(hi).LineWidth=3;
h(hi).Marker='o';
h(hi).Color=colors(hi,:);
end
xlabel('Fixation Number');
ylabel(metric_name);
switch metric_eval
    case 13
        ylim([0 20]); 
        yticks([0 5 10 15]);
    case 14
        ylim([0 20]); 
        yticks([0 5 10 15]);
    case 17
        ylim([0 20]); 
        yticks([0 5 10 15]);
end
set(gcf,'units','points','position',[10,10,350,150]);
set(gcf,'units','points','position',[10,10,256,120]);
xticks(1:G);
if metric_eval==13 && strcmp(dataset_name,'tsotsos')
lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; 
lgd.Position=[0.7979    0.5274    0.1916    0.2609];
% lgd.Position=[.80 .82 .20 .18];
end

saveas2(gcf,['figs/' 'quantitative' '/' dataset_name '_' metric_name_old '.png']);


%% correlation
if metric_eval==14
    results_gazewise_clean(1,:)=results_gazewise(1,~isnan(results_gazewise(1,:))); %GT
    for m=2:length(model_names)
        results_gazewise_clean(m,:)=results_gazewise(m,~isnan(results_gazewise(1,:)));
    end
    % results_gazewise=results_gazewise_clean;

    for m=2:length(model_names)
       [corrs(m-1),pvals(m-1)]=corr(results_gazewise_clean(1,:)',results_gazewise_clean(m,:)');
    end
    h=coloredbar(corrs,model_names_alt(:,2:end),colors_cell(:,2:end));
    ylabel(['\rho(SA)']);
    % ylim([-.2 .2]);
    set(gcf,'units','points','position',[10,10,256,120]);
    saveas(gcf,['figs/' 'quantitative' '/' dataset_name '_' metric_name_old '_corr' '.png']);
    corr_cell_results=[model_names_alt(:,2:end);num2cell(corrs);num2cell(pvals)]';
    w_csv(corr_cell_results,['figs/quantitative/' dataset_name '_rho' '_'  metric_name '.csv']);
end

end








% metrics_toeval=[9,15,16,18:29];
% datasets={'tsotsos','kootstra','cat2000_nopad','sid4vam'}
% for d=1:length(datasets)
%     for m=1:length(metrics_toeval)
%         plot_metrics_generic( datasets{d}, metrics_toeval(m), '/media/dberga/DATA/repos/metrics_saliency/output' , {'dmaps','CLE','LeMeur','LeMeur_faces','LeMeur_landscapes','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'})
%     end
% end







