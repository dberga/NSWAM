function [mean_samplitude_diff, mean_slanding, mean_samplitude] = test_ior( img_path, model_name,dataset_out_path, GT_path, gazesnum, ior_decay,ior_peak,ior_std_angle )


if nargin <1, img_path=['input/111.png']; end
if nargin <2, model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault'; end %no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault
if nargin <3, dataset_out_path='/home/dberga/repos/metrics_saliency/input/smaps/tsotsos_original_reserva'; end
if nargin<4, GT_path='/home/dberga/repos/metrics_saliency/input/scanpaths/tsotsos'; end
if nargin<5, gazesnum=10; end
if nargin<6,ior_decay=[1]; end
% if nargin<6,ior_decay=[1 0.999 0.99 .95 0.9 0.75 0.5 0.25 0]; end
%  if nargin<6,ior_decay=[0 .25 .5 .75 nthroot(0.001,(1:8)*100)]; end
if nargin<7, ior_peak=1; end
visualize=2;

[imgfolder,imgname,imgext]=fileparts(img_path);
img=double(imread(img_path))./255;
smap_path=[dataset_out_path '/' model_name '/' imgname '.png'];
smap=double(imread(smap_path))./255;

pxva=32; %pxva=rad2deg(0.6130); pxva=35.12;
if nargin<8, 
%     ior_std_angle=6*(size(smap,1)./pxva); %itti
%     ior_std_angle=pxva*4; 
%     ior_std_angle=pxva*2; 
    ior_std_angle=[pxva*0 pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7 pxva*8];
end


load([GT_path '/' imgname '.mat']);
GT_scanpaths_pp=scanpath;


mkdir(['figs' '/ior/test']);
if length(ior_decay)>1 && length(ior_std_angle)<2
    mkdir(['figs' '/' 'ior/test' '/' 'std' num2str(ior_std_angle)]);
    for d=1:length(ior_decay)
        [scanpath,smaps,mean_smap]=staticsaliency2scanpath(smap,gazesnum,ior_decay(d),ior_peak,ior_std_angle);
        scanpath(2,:)=[453 192];
        [ mean_amplitude_decay(d)] = samplitude( scanpath );
        [ mean_amplitude_diff_decay(d), std_amplitude_diff_decay(d), amplitudes_diff_decay(d,:)  ] = pp_samplitude_diff( GT_scanpaths_pp,scanpath );
        [ mean_distance_decay(d), std_distance_decay(d), distances_decay(d,:) ] = pp_slanding( GT_scanpaths_pp, scanpath );
        if visualize==1
        superpos_sp=superpos_scanpath( img,scanpath,gazesnum,pxva,[ 0 1 0;1 0 0; 1 0 0; 0 0 0],false );
        imwrite2(superpos_sp,['figs' '/' 'ior/test' '/' 'std' num2str(ior_std_angle) '/' model_name '_' imgname '_decay_' num2str(ior_decay(d))  '.png'],true);
        end
    end
    mean_samplitude=mean_amplitude_decay;
    mean_samplitude_diff=mean_amplitude_diff_decay;
    mean_slanding=mean_distance_decay;
    if visualize==2
    plot(ior_decay,mean_amplitude_diff_decay/pxva,'LineWidth',2,'Marker','o','Color','red'); ylabel('\DeltaSA Error (deg)'); xlabel('IoR Decay, \beta_{IoR}'); 
    xlim([0 1]); xticks([0 .25 .5 .75 .93 1]);
    lgd=legend({'NSWAM+IoR'});
    set(gcf, 'Position',  [10, 10, 300, 200]); set(gcf, 'Position',  [10, 10, 300, 200]); 
    saveas(gcf,['figs' '/' 'ior/test' '/' 'std' num2str(ior_std_angle) '/' 'DSA_' model_name '_' imgname  '.png']);
    plot(ior_decay,mean_distance_decay/pxva,'LineWidth',2,'Marker','o','Color','red'); ylabel('\DeltaSL Error (deg)'); xlabel('IoR Decay, \beta_{IoR}'); 
    xlim([0 1]); xticks([0 .25 .5 .75 .93 1]); lgd.Position=[.19 .65 .39 .095];
    lgd=legend({'NSWAM+IoR'});
    set(gcf, 'Position',  [10, 10, 300, 200]); set(gcf, 'Position',  [10, 10, 300, 200]); 
    saveas(gcf,['figs' '/' 'ior/test' '/' 'std' num2str(ior_std_angle) '/' 'DSL_' model_name '_' imgname  '.png']);
    
    end
end


mean_amplitude_diff_angle=[];
std_amplitude_diff_angle=[];
amplitudes_diff_angle=[];
mean_distance_angle=[];
std_distance_angle=[];
distances_angle=[];
if length(ior_std_angle)>1 && length(ior_decay)<2
    mkdir(['figs' '/' 'ior/test' '/' 'decay' num2str(ior_decay)]);
    for sd=1:length(ior_std_angle)
        [scanpath,smaps,mean_smap]=staticsaliency2scanpath(smap,gazesnum,ior_decay,ior_peak,ior_std_angle(sd));
        scanpath(2,:)=[453 192];
        [ mean_amplitude_angle(sd)] = samplitude( scanpath );
        [ mean_amplitude_diff_angle(sd), std_amplitude_diff_angle(sd), amplitudes_diff_angle(sd,:)  ] = pp_samplitude_diff( GT_scanpaths_pp,scanpath );
        [ mean_distance_angle(sd), std_distance_angle(sd), distances_angle(sd,:) ] = pp_slanding( GT_scanpaths_pp, scanpath );
        if visualize==1
        superpos_sp=superpos_scanpath( img,scanpath,gazesnum,pxva,[ 0 1 0;1 0 0; 1 0 0; 0 0 0],false );
        imwrite2(superpos_sp,['figs' '/' 'ior/test' '/' 'decay' num2str(ior_decay) '/' model_name '_' imgname '_std_' num2str(ior_std_angle(sd))  '.png'],true);
        end
    end
    mean_samplitude=mean_amplitude_angle;
    mean_samplitude_diff=mean_amplitude_diff_angle;
    mean_slanding=mean_distance_angle;
    if visualize==2
    plot(ior_std_angle/pxva,mean_amplitude_diff_angle/pxva,'LineWidth',2,'Marker','o','Color','red'); ylabel('\DeltaSA Error (deg)'); xlabel('Ior Size, \sigma_{IoR} (deg)'); 
    xticks([0:8]);
    lgd=legend({'NSWAM+IoR'});
    set(gcf, 'Position',  [10, 10, 300, 200]); set(gcf, 'Position',  [10, 10, 300, 200]); 
    saveas(gcf,['figs' '/' 'ior/test' '/' 'decay' num2str(ior_decay) '/' 'DSA_' model_name '_' imgname  '.png']);
    plot(ior_std_angle/pxva,mean_distance_angle/pxva,'LineWidth',2,'Marker','o','Color','red'); ylabel('\DeltaSL Error (deg)'); xlabel('Ior Size, \sigma_{IoR} (deg)'); 
    xticks([0:8]);
    lgd=legend({'NSWAM+IoR'});
    set(gcf, 'Position',  [10, 10, 300, 200]); set(gcf, 'Position',  [10, 10, 300, 200]); 
    saveas(gcf,['figs' '/' 'ior/test' '/' 'decay' num2str(ior_decay) '/' 'DSL_' model_name '_' imgname  '.png']);
    end
end

mkdir(['figs' '/' 'ior/qualitative']);
% if length(ior_std_angle)>1 && length(ior_decay)>1
    for sd=1:length(ior_std_angle)
        for d=1:length(ior_decay)
            [scanpath,smaps,mean_smap]=staticsaliency2scanpath(smap,gazesnum,ior_decay(d),ior_peak,ior_std_angle(sd));
            scanpath(2,:)=[453 192];
            superpos_sp=superpos_scanpath( img,scanpath,gazesnum,pxva,[ 1 0 0;1 0 0; 1 0 0; 0 0 0],false );
            imwrite2(superpos_sp,['figs' '/' 'ior/qualitative' '/' model_name '_' imgname '_decay_' num2str(ior_decay(d))  '_std_' num2str(ior_std_angle(sd))  '.png'],1);
        end
    end
% end


end
