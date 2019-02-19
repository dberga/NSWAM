function [  ] = plot_ior_static_properties( datasets ,pxvas, model_name)

if nargin<1, datasets={'tsotsos','kootstra','cat2000_nopad','sid4vam'}; end
if nargin<2, pxvas=[32, 34, 38, 40]; end
if nargin<3, model_names={'no_cortical_config_b1_15_sqmean_fusion2_invdefault'}; end


for d=1:length(datasets) %parameters to test
    ior_std_angle_default{d}=[pxvas(d)*1 pxvas(d)*2 pxvas(d)*3 pxvas(d)*4 pxvas(d)*5 pxvas(d)*6 pxvas(d)*7 pxvas(d)*8];
    ior_decay_default=[1 0.999 0.99 0.9 0.75 0.5 0.25 0];
end


if ~exist('figs/quantitative/ior_statistics/ior_statistics.mat') 
    
    for d=1:length(datasets)  
        for m=1:length(model_names)
        [iorangle_mean_samplitude_diffs{m}{d},iorangle_mean_slandings{m}{d},iorangle_mean_samplitude{m}{d},iordecay_mean_samplitude_diffs{m}{d},iordecay_mean_slandings{m}{d},iordecay_mean_samplitude{m}{d} ] = test_ior_static_dataset( datasets{d}, pxvas(d), model_names{m} ,ior_std_angle_default{d},ior_decay_default);
        end
    end
    save('figs/quantitative/ior_statistics.mat','iorangle_mean_samplitude_diffs','iorangle_mean_slandings','iorangle_mean_samplitude','iordecay_mean_samplitude_diffs','iordecay_mean_slandings','iordecay_mean_samplitude');
else
    load 'figs/quantitative/ior_statistics.mat';
    for m=1:length(model_names)
    plot_ior_properties_perdataset(model_names{m},datasets,iorangle_mean_samplitude_diffs{m},iorangle_mean_slandings{m},iorangle_mean_samplitude{m},iordecay_mean_samplitude_diffs{m},iordecay_mean_slandings{m},iordecay_mean_samplitude{m});
    end
    plot_ior_properties(model_names,datasets,iorangle_mean_samplitude_diffs,iorangle_mean_slandings,iorangle_mean_samplitude,iordecay_mean_samplitude_diffs,iordecay_mean_slandings,iordecay_mean_samplitude);
end


end

function [] = plot_ior_properties_perdataset(model_name,datasets,iorangle_mean_samplitude_diffs,iorangle_mean_slandings,iorangle_mean_samplitude,iordecay_mean_samplitude_diffs,iordecay_mean_slandings,iordecay_mean_samplitude)
    %angle vs samplitude diff
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iorangle_mean_samplitude_diffs{d},1));
    end
    title(model_name);
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/' model_name '_SADiffvsSIGMA.png']);
    %angle vs slanding
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iorangle_mean_slandings{d},1));
    end
    title(model_name);
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/' model_name '_SLDiffvsSIGMA.png']);
    %angle vs samplitude
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iorangle_mean_samplitude{d},1));
    end
    title(model_name);
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/' model_name '_SAvsSIGMA.png']);
    
    %decay vs samplitude diff
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iordecay_mean_samplitude_diffs{d},1));
    end
    title(model_name);
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/' model_name '_SADiffvsBETA.png']);
    %decay vs slanding
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iordecay_mean_slandings{d},1));
    end
    title(model_name);
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/' model_name '_SLDiffvsBETA.png']);
    %decay vs samplitude
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iordecay_mean_samplitude{d},1));
    end
    title(model_name);
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/' model_name '_SAvsBETA.png']);
end

function [] = plot_ior_properties(model_names,datasets,iorangle_mean_samplitude_diffs,iorangle_mean_slandings,iorangle_mean_samplitude,iordecay_mean_samplitude_diffs,iordecay_mean_slandings,iordecay_mean_samplitude)
    for d=1:length(datasets)
        
        hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_decay_default,nanmean(iorangle_mean_samplitude_diffs{m}{d},1));
        end
        hold off
        title(datasets{d});
        legend(model_names);
        saveas2(gcf,['figs/quantitative/ior_statistics/' datasets{d} '_SADiffvsSIGMA.png']);
        
        hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_decay_default,nanmean(iorangle_mean_slandings{m}{d},1));
        end
        hold off
        title(datasets{d});
        legend(model_names);
        saveas2(gcf,['figs/quantitative/ior_statistics/' datasets{d} '_SLDiffvsSIGMA.png']);
        
        hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_decay_default,nanmean(iorangle_mean_samplitude{m}{d},1));
        end
        hold off
        title(datasets{d});
        legend(model_names);
        saveas2(gcf,['figs/quantitative/ior_statistics/' datasets{d} '_SAvsSIGMA.png']);
        
        hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_decay_default,nanmean(iordecay_mean_samplitude_diffs{m}{d},1));
        end
        hold off
        title(datasets{d});
        legend(model_names);
        saveas2(gcf,['figs/quantitative/ior_statistics/' datasets{d} '_SADiffvsBETA.png']);
        
        hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_decay_default,nanmean(iordecay_mean_slandings{m}{d},1));
        end
        hold off
        title(datasets{d});
        legend(model_names);
        saveas2(gcf,['figs/quantitative/ior_statistics/' datasets{d} '_SLDiffvsBETA.png']);
        
        hold on
        title(datasets{d});
        for m=1:length(model_names)
            plot(ior_decay_default,nanmean(iordecay_mean_samplitude{m}{d},1));
        end
        hold off
        title(datasets{d});
        legend(model_names);
        saveas2(gcf,['figs/quantitative/ior_statistics/' datasets{d} '_SAvsBETA.png']);
        
    end
end
