function [ ] = plot_metrics_generic( dataset_name, metrics_output_path , model_names, metric_eval)

if nargin<4, metric_eval=10; end %10=sAUC
if nargin<3, 
    model_names={'dmaps','IttiKochNiebur','AIM','abs_no_cortical_config_b1_15_sqmean_fusion2_invdefault','no_cortical_config_b1_15_sqmean_fusion2_invdefault','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; 
    model_names_alt={'GT','IKN','AIM','SWAM','NSWAM','NSWAM-CM'}; else, model_names_alt=model_names; end
if nargin<2, metrics_output_path='/media/dberga/DATA/repos/metrics_saliency/output'; end
if nargin<1, dataset_name='tsotsos'; end %dataset_name='tmp/cat2000_nopad';

results=zeros(length(model_names),1);
for m=1:length(model_names)
    try
    load([metrics_output_path '/' dataset_name '/' model_names{m} '/' 'results.mat']);
    %sAUC
    results(m)=results_struct.metrics{metric_eval}.score;
    end
end



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

G=10; %fixation num max
results_gazewise=NaN.*ones(length(model_names),G);
for m=1:length(model_names)
    try
    load([metrics_output_path '/' dataset_name '/' model_names{m} '/' 'results.mat']);
    results_gazewise(m,1:G)=cell2mat(results_struct.metrics_gazewise{metric_eval}.score(1:G));
    end
end

h=plot(1:G,results_gazewise);
legend(model_names_alt);
ylim([min(results_gazewise(:))-0.02 max(results_gazewise(:))+0.02]);
h(1).LineWidth=8;
h(2).LineWidth=8;
h(2).LineWidth=5;
h(2).LineWidth=4;
h(2).LineWidth=3;
h(1).LineWidth=3;
h(3).LineWidth=3;
h(4).LineWidth=3;
h(5).LineWidth=3;
h(6).LineWidth=3;

end

