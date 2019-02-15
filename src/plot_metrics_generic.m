function [ ] = plot_metrics_generic( dataset_name, metric_eval, metrics_output_path , model_names)

if nargin<4, 
    model_names={'dmaps','IttiKochNiebur','AIM','no_cortical_config_b1_15_sqmean_fusion2_invdefault','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'};  %abs_no_cortical_config_b1_15_sqmean_fusion2_invdefault
    model_names_alt={'GT','IKN','AIM','NSWAM','NSWAM-CM'}; else, model_names_alt=model_names; end %SWAM
if nargin<3, metrics_output_path='/media/dberga/DATA/repos/metrics_saliency/output'; end
if nargin<2, metric_eval=2; end %10=sAUC
if nargin<1, dataset_name='tsotsos'; end %dataset_name='tmp/cat2000_nopad';

colors=[0 0 0;  0 0 1; 1 .75 0; 0 1 0; 1 0 0];


results=zeros(length(model_names),1);
for m=1:length(model_names)
    try
    load([metrics_output_path '/' dataset_name '/' model_names{m} '/' 'results.mat']);
    %sAUC
    results(m)=results_struct.metrics{metric_eval}.score;
    end
end

metric_name=results_struct.metrics{metric_eval}.name; 
metric_name=strrep(metric_name,'_','-'); %substrings only for 1 char in matlab
metric_name=strrep(metric_name,'-trials','');
metric_name=strrep(metric_name,'-Borji','');
mkdir(['figs/' 'quantitative' '/']);

%% bar plot for metric result
h=bar(results);
%title([]);
xticklabels(model_names_alt);
xtickangle(45);
%xlabel(blocks_labels{b}{1});
%ylabel(metric_name);
%if max(results(:))>0.2, ylim([0.2 1]); else, ylim([min(ylims), max(ylims)]); end
ylim([min(results(:))-0.02 max(results(:))+0.02]);
%h(1).FaceColor=[0 0 0];
%set(gcf,'units','points','position',[10,10,500,175]);
close all;

%% plot for metric result per gaze
G=10; %fixation num max
results_gazewise=NaN.*ones(length(model_names),G);
for m=1:length(model_names)
    try
    load([metrics_output_path '/' dataset_name '/' model_names{m} '/' 'results.mat']);
    results_gazewise(m,1:G)=cell2mat(results_struct.metrics_gazewise{metric_eval}.score(1:G));
    end
end

%erase GT for better representation
results_gazewise(1,:)=[];
colors(1,:)=[];
model_names_alt(:,1)=[];

h=plot(1:G,results_gazewise);
xlim([1,G]);
ylim([min(results_gazewise(:))-0.02 max(results_gazewise(:))+0.02]);
for hi=1:length(h)
h(hi).LineWidth=3;
h(hi).Color=colors(hi,:);
end
xlabel('Fixation Number');
ylabel(metric_name);
set(gcf,'units','points','position',[10,10,350,150]);
xticks(1:G);
lgd=legend(model_names_alt); lgd.FontSize = 5; lgd.FontWeight='bold'; lgd.Position=[.80 .82 .20 .18];
saveas2(gcf,['figs/' 'quantitative' '/' dataset_name '_' metric_name '.png']);




end

