function [  ] = plot_ior_static_properties( datasets ,pxvas, model_names)

if nargin<1, datasets={'tsotsos','kootstra','cat2000_nopad','sid4vam'}; end
if nargin<2, pxvas=[32, 34, 38, 40]; end
if nargin<3, model_names={'no_cortical_config_b1_15_sqmean_fusion2_invdefault','no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault'}; end
model_names_alt={'NSWAM+IoR','NSWAM-CM+IoR'};
datasets_alt={'Toronto','KTH','CAT2000_P','SID4VAM'};

for d=1:length(datasets) %parameters to test
    ior_std_angle_default{d}=[pxvas(d)*0 pxvas(d)*1 pxvas(d)*2 pxvas(d)*3 pxvas(d)*4 pxvas(d)*5 pxvas(d)*6 pxvas(d)*7 pxvas(d)*8];
%     ior_decay_default=[1 0.999 0.99 0.95 0.9 0.75 0.5 0.25 0];
    ior_decay_default=[0 .25 .5 .75 nthroot(0.001,(1:10)*100) 1];
end

mkdir('figs/ior'); 
if ~exist(['figs/ior/ior_statistics.mat']) 
    
    for d=1:length(datasets)  
        for m=1:length(model_names)
        [iorangle_mean_samplitude_diffs{m}{d},iorangle_mean_slandings{m}{d},iorangle_mean_samplitude{m}{d},iordecay_mean_samplitude_diffs{m}{d},iordecay_mean_slandings{m}{d},iordecay_mean_samplitude{m}{d} ] = test_ior_static_dataset( datasets{d}, pxvas(d), model_names{m} ,ior_std_angle_default{d},ior_decay_default);
        end
    end
    save('figs/ior/ior_statistics.mat','iorangle_mean_samplitude_diffs','iorangle_mean_slandings','iorangle_mean_samplitude','iordecay_mean_samplitude_diffs','iordecay_mean_slandings','iordecay_mean_samplitude');
else
    load 'figs/ior/ior_statistics.mat';
    for m=1:length(model_names)
        plot_ior_properties_perdataset(model_names_alt{m},datasets_alt,pxvas,ior_std_angle_default,ior_decay_default,iorangle_mean_samplitude_diffs{m},iorangle_mean_slandings{m},iorangle_mean_samplitude{m},iordecay_mean_samplitude_diffs{m},iordecay_mean_slandings{m},iordecay_mean_samplitude{m});
    end
%     plot_ior_properties(model_names_alt,datasets_alt,pxvas,ior_std_angle_default{d},ior_decay_default,iorangle_mean_samplitude_diffs,iorangle_mean_slandings,iorangle_mean_samplitude,iordecay_mean_samplitude_diffs,iordecay_mean_slandings,iordecay_mean_samplitude);
end


end

function [] = plot_ior_properties_perdataset(model_name,datasets,pxvas,ior_std_angle_default,ior_decay_default,iorangle_mean_samplitude_diffs,iorangle_mean_slandings,iorangle_mean_samplitude,iordecay_mean_samplitude_diffs,iordecay_mean_slandings,iordecay_mean_samplitude)

    xticks_default = [0 .25 .5 .75 .93 1];
%     xticks_default = ior_decay_default;
    markers_datasets={'s','o','x','*'};
    markers_colors_datasets={[0 0 0],[0.25 0.25 0.25],[0.50 0.50 0.50],[0.75 0.75 0.75]};
    %angle vs samplitude diff
    close all; hold on
    for d=1:length(datasets)  
        h(d)=plot(ior_std_angle_default{d}./pxvas(d),nanmean(iorangle_mean_samplitude_diffs{d},1)./pxvas(d),'LineWidth',2,'Marker',markers_datasets{d},'Color',markers_colors_datasets{d});
    end
    %title(model_name);
    lgd=legend(datasets);   lgd.FontSize=6; lgd.Position=[.72 .29 .26 .25];
    ylabel('\DeltaSA Error (deg)');
    xlabel('IoR Size, \sigma_{IoR} (deg)');
    hold off
    xticks(ior_std_angle_default{d}./pxvas(d)); xlim([min(ior_std_angle_default{d}./pxvas(d)) max(ior_std_angle_default{d}./pxvas(d))]);
    set(gcf, 'Position',  [10, 10, 300, 200]); set(gcf, 'Position',  [10, 10, 300, 200]); 
    saveas(gcf,['figs/ior/' model_name '_SADiffvsSIGMA.png']);
    
    %angle vs slanding
    close all; hold on
    for d=1:length(datasets)  
        plot(ior_std_angle_default{d}./pxvas(d),nanmean(iorangle_mean_slandings{d},1)./pxvas(d),'LineWidth',2,'Marker',markers_datasets{d},'Color',markers_colors_datasets{d});
    end
    %title(model_name);
    %lgd=legend(datasets);  lgd.FontSize=6; lgd.Position=[.77 .53 .22 .15];
    ylabel('\DeltaSL Error (deg)');
    xlabel('IoR Size, \sigma_{IoR} (deg)');
    xticks(ior_std_angle_default{d}./pxvas(d)); xlim([min(ior_std_angle_default{d}./pxvas(d)) max(ior_std_angle_default{d}./pxvas(d))]);
    hold off
    set(gcf, 'Position',  [10, 10, 300, 200]); set(gcf, 'Position',  [10, 10, 300, 200]); 
    saveas(gcf,['figs/ior/' model_name '_SLDiffvsSIGMA.png']);
    
    %angle vs samplitude
    close all; hold on
    for d=1:length(datasets)  
        h=plot(ior_std_angle_default{d}./pxvas(d),nanmean(iorangle_mean_samplitude{d},1)./pxvas(d),'LineWidth',2,'Marker',markers_datasets{d},'Color',markers_colors_datasets{d});
    end
    %title(model_name);
    %lgd=legend(datasets); lgd.FontSize=6; lgd.Position=[.77 .84 .22 .15];
    ylabel('SA (deg)');
    xlabel('IoR Size, \sigma_{IoR} (deg)');
    hold off
    xticks(ior_std_angle_default{d}./pxvas(d)); xlim([min(ior_std_angle_default{d}./pxvas(d)) max(ior_std_angle_default{d}./pxvas(d))]);
    set(gcf, 'Position',  [10, 10, 300, 200]); set(gcf, 'Position',  [10, 10, 300, 200]); 
    saveas(gcf,['figs/ior/' model_name '_SAvsSIGMA.png']);
    
    %decay vs samplitude diff
    close all; hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iordecay_mean_samplitude_diffs{d},1)./pxvas(d),'LineWidth',2,'Marker',markers_datasets{d},'Color',markers_colors_datasets{d});
    end
    %title(model_name);
    %lgd=legend(datasets);  lgd.FontSize=6; lgd.Position=[.77 .84 .22 .15];
    ylabel('\DeltaSA Error (deg)');
    xlabel('IoR Decay, \beta_{IoR} (deg)');
    xticks(sort(xticks_default)); xlim([min(xticks_default) max(xticks_default)]);
    hold off
    set(gcf, 'Position',  [10, 10, 300, 200]); set(gcf, 'Position',  [10, 10, 300, 200]); 
    saveas(gcf,['figs/ior/' model_name '_SADiffvsBETA.png']);
    
    %decay vs slanding
    close all; hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iordecay_mean_slandings{d},1)./pxvas(d),'LineWidth',2,'Marker',markers_datasets{d},'Color',markers_colors_datasets{d});
    end
    %title(model_name);
    %lgd=legend(datasets);  lgd.FontSize=6; lgd.Position=[.77 .84 .22 .15];
    ylabel('\DeltaSL Error (deg)');
    xlabel('IoR Decay, \beta_{IoR} (deg)');
    xticks(sort(xticks_default)); xlim([min(xticks_default) max(xticks_default)]);
    hold off
    set(gcf, 'Position',  [10, 10, 300, 200]); set(gcf, 'Position',  [10, 10, 300, 200]); 
    saveas(gcf,['figs/ior/' model_name '_SLDiffvsBETA.png']);
    
    %decay vs samplitude
    close all; hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iordecay_mean_samplitude{d},1)./pxvas(d),'LineWidth',2,'Marker',markers_datasets{d},'Color',markers_colors_datasets{d});
    end
    %title(model_name);
    %lgd=legend(datasets);  lgd.FontSize=6; lgd.Position=[.77 .84 .22 .15];
    ylabel('SA (deg)');
    xlabel('IoR Decay, \beta_{IoR} (deg)');
    xticks(sort(xticks_default)); xlim([min(xticks_default) max(xticks_default)]);
    hold off
    set(gcf, 'Position',  [10, 10, 300, 200]); set(gcf, 'Position',  [10, 10, 300, 200]); 
    saveas(gcf,['figs/ior/' model_name '_SAvsBETA.png']);
end

function [] = plot_ior_properties(model_names,datasets,pxvas,ior_std_angle_default,ior_decay_default,iorangle_mean_samplitude_diffs,iorangle_mean_slandings,iorangle_mean_samplitude,iordecay_mean_samplitude_diffs,iordecay_mean_slandings,iordecay_mean_samplitude)
    
    
    for d=1:length(datasets)
        
        close all; hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_std_angle_default,nanmean(iorangle_mean_samplitude_diffs{m}{d},1)./pxvas(d),'LineWidth',4);
        end
        hold off
        title(datasets{d});
        legend(model_names);
        ylabel('\DeltaSA Error (deg)');
        xlabel('IoR Size, \sigma_{IoR} (deg)');
        set(gcf, 'Position',  [10, 10, 300, 200]);
        saveas2(gcf,['figs/ior/ior_statistics/' datasets{d} '_SADiffvsSIGMA.png']);
        
        close all; hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_std_angle_default,nanmean(iorangle_mean_slandings{m}{d},1)./pxvas(d),'LineWidth',4);
        end
        hold off
        title(datasets{d});
        legend(model_names);
        ylabel('\DeltaSL Error (deg)');
        xlabel('IoR Size, \sigma_{IoR} (deg)');
        set(gcf, 'Position',  [10, 10, 300, 200]);
        saveas2(gcf,['figs/ior/ior_statistics/' datasets{d} '_SLDiffvsSIGMA.png']);
        
        close all; hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_std_angle_default,nanmean(iorangle_mean_samplitude{m}{d},1)./pxvas(d),'LineWidth',4);
        end
        hold off
        title(datasets{d});
        legend(model_names);
        ylabel('SA (deg)');
        xlabel('IoR Size, \sigma_{IoR} (deg)');
        set(gcf, 'Position',  [10, 10, 300, 200]);
        saveas2(gcf,['figs/ior/ior_statistics/' datasets{d} '_SAvsSIGMA.png']);
        
        close all; hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_decay_default,nanmean(iordecay_mean_samplitude_diffs{m}{d},1)./pxvas(d),'LineWidth',4);
        end
        hold off
        title(datasets{d});
        legend(model_names);
        ylabel('\DeltaSA Error (deg)');
        xlabel('IoR Decay, \beta_{IoR} (deg)');
        set(gcf, 'Position',  [10, 10, 300, 200]);
        saveas2(gcf,['figs/ior/ior_statistics/' datasets{d} '_SADiffvsBETA.png']);
        
        close all; hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_decay_default,nanmean(iordecay_mean_slandings{m}{d},1)./pxvas(d),'LineWidth',4);
        end
        hold off
        title(datasets{d});
        legend(model_names);
        ylabel('\DeltaSL Error (deg)');
        xlabel('IoR Decay, \beta_{IoR} (deg)');
        set(gcf, 'Position',  [10, 10, 300, 200]);
        saveas2(gcf,['figs/ior/ior_statistics/' datasets{d} '_SLDiffvsBETA.png']);
        
        close all; hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_decay_default,nanmean(iordecay_mean_samplitude{m}{d},1)./pxvas(d),'LineWidth',4);
        end
        hold off
        title(datasets{d});
        legend(model_names);
        ylabel('SA (deg)');
        xlabel('IoR Decay, \beta_{IoR} (deg)');
        set(gcf, 'Position',  [10, 10, 300, 200]);
        saveas2(gcf,['figs/ior/ior_statistics/' datasets{d} '_SAvsBETA.png']);
        
    end
end
