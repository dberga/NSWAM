function [  ] = plot_ior_static_properties( datasets ,pxvas, model_name)

if nargin<1, datasets={'tsotsos','kootstra','cat2000_nopad','sid4vam'}; end
if nargin<2, pxvas=[32, 34, 38, 40]; end
if nargin<3, model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault'; end


for d=1:length(datasets) %parameters to test
    ior_std_angle_default{d}=[pxvas(d)*1 pxvas(d)*2 pxvas(d)*3 pxvas(d)*4 pxvas(d)*5 pxvas(d)*6 pxvas(d)*7 pxvas(d)*8];
    ior_decay_default=[1 0.999 0.99 0.9 0.75 0.5 0.25 0];
end


if ~exist('figs/quantitative/ior_statistics/iorangle_mean_samplitude_diffs.mat') %could assert others
    
    for d=1:length(datasets)  
        [iorangle_mean_samplitude_diffs{d},iorangle_mean_slandings{d},iorangle_mean_samplitude{d},iordecay_mean_samplitude_diffs{d},iordecay_mean_slandings{d},iordecay_mean_samplitude{d} ] = test_ior_static_dataset( datasets{d}, pxvas(d), model_name ,ior_std_angle_default{d},ior_decay_default);
    end
    mkdir('figs/quantitative/ior_statistics/');
    save('figs/quantitative/ior_statistics/iorangle_mean_samplitude_diffs.mat','iorangle_mean_samplitude_diffs');
    save('figs/quantitative/ior_statistics/iorangle_mean_slandings.mat','iorangle_mean_slandings');
    save('figs/quantitative/ior_statistics/iorangle_mean_samplitude.mat','iorangle_mean_samplitude');

    save('figs/quantitative/ior_statistics/iordecay_mean_samplitude_diffs.mat','iordecay_mean_samplitude_diffs');
    save('figs/quantitative/ior_statistics/iordecay_mean_slandings.mat','iordecay_mean_slandings');
    save('figs/quantitative/ior_statistics/iordecay_mean_samplitude.mat','iordecay_mean_samplitude');
else
    load 'figs/quantitative/ior_statistics/iorangle_mean_samplitude_diffs.mat';
    load 'figs/quantitative/ior_statistics/iorangle_mean_slandings.mat';
    load 'figs/quantitative/ior_statistics/iorangle_mean_samplitude.mat';
    
    load 'figs/quantitative/ior_statistics/iordecay_mean_samplitude_diffs.mat';
    load 'figs/quantitative/ior_statistics/iordecay_mean_slandings.mat';
    load 'figs/quantitative/ior_statistics/iordecay_mean_samplitude.mat';
    
    %angle vs samplitude diff
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iorangle_mean_samplitude_diffs{d},1));
    end
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/SADiffvsSIGMA.png']);
    %angle vs slanding
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iorangle_mean_slandings{d},1));
    end
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/SLDiffvsSIGMA.png']);
    %angle vs samplitude
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iorangle_mean_samplitude{d},1));
    end
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/SLvsSIGMA.png']);
    
    %decay vs samplitude diff
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iordecay_mean_samplitude_diffs{d},1));
    end
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/SADiffvsBETA.png']);
    %decay vs slanding
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iordecay_mean_slandings{d},1));
    end
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/SLDiffvsBETA.png']);
    %decay vs samplitude
    hold on
    for d=1:length(datasets)  
        plot(ior_decay_default,nanmean(iordecay_mean_samplitude{d},1));
    end
    legend(datasets);
    hold off
    saveas2(gcf,['figs/quantitative/ior_statistics/SAvsBETA.png']);
end


end

