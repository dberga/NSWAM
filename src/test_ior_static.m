function [mean_samplitude_diff, mean_slanding] = test_ior( img_path, model_name,dataset_out_path, GT_path, gazesnum, ior_decay,ior_peak,ior_std_angle )


if nargin <1, img_path=['input/111.png']; end
if nargin <2, model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault'; end %no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault
if nargin <3, dataset_out_path='output_tsotsos'; end
if nargin<4, GT_path='/home/dberga/repos/metrics_saliency/input/scanpaths/tsotsos'; end
if nargin<5, gazesnum=10; end
if nargin<6,ior_decay=[0.999]; end
% if nargin<6,ior_decay=[0.999 0.99 0.9 0.75 0]; end
if nargin<7, ior_peak=1; end
visualize=false;
    
[imgfolder,imgname,imgext]=fileparts(img_path);
img=double(imread(img_path))./255;
smap_path=[dataset_out_path '/' model_name '/' imgname '.png'];
smap=double(imread(smap_path))./255;

pxva=40; %pxva=rad2deg(0.6130); pxva=35.12;
if nargin<8, 
%     ior_std_angle=6*(size(smap,1)./pxva); %itti
%     ior_std_angle=pxva*6; 
    ior_std_angle=[pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7];
end


load([GT_path '/' imgname '.mat']);
GT_scanpaths_pp=scanpath;

 
mkdir(['figs' '/scanpaths3']);
if length(ior_decay)>1 && length(ior_std_angle)<2
    mkdir(['figs' '/' 'scanpaths3' '/' 'std' num2str(ior_std_angle)]);
    for d=1:length(ior_decay)
        [scanpath,smaps,mean_smap]=staticsaliency2scanpath(smap,gazesnum,ior_decay(d),ior_peak,ior_std_angle);
        [ mean_amplitude_diff_decay(d), std_amplitude_diff_decay(d), amplitudes_diff_decay(d,:)  ] = pp_samplitude_diff( GT_scanpaths_pp,scanpath );
        [ mean_distance_decay(d), std_distance_decay(d), distances_decay(d,:) ] = pp_slanding( GT_scanpaths_pp, scanpath );
        if visualize
        superpos_sp=superpos_scanpath( img,scanpath,gazesnum,pxva,[ 0 1 0;1 0 0; 1 0 0; 0 0 0],false );
        imwrite2(superpos_sp,['figs' '/' 'scanpaths3' '/' 'std' num2str(ior_std_angle) '/' model_name '_' imgname '_decay_' num2str(ior_decay(d))  '.png'],false);
        end
    end
    mean_samplitude_diff=mean_amplitude_diff_decay;
    mean_slanding=mean_distance_decay;
end
if visualize
plot(ior_decay,mean_amplitude_diff_decay);
plot(ior_decay,mean_distance_decay);
end

mean_amplitude_diff_angle=[];
std_amplitude_diff_angle=[];
amplitudes_diff_angle=[];
mean_distance_angle=[];
std_distance_angle=[];
distances_angle=[];
if length(ior_std_angle)>1 && length(ior_decay)<2
    mkdir(['figs' '/' 'scanpaths3' '/' 'decay' num2str(ior_decay)]);
    for sd=1:length(ior_std_angle)
        [scanpath,smaps,mean_smap]=staticsaliency2scanpath(smap,gazesnum,ior_decay,ior_peak,ior_std_angle(sd));
        [ mean_amplitude_diff_angle(sd), std_amplitude_diff_angle(sd), amplitudes_diff_angle(sd,:)  ] = pp_samplitude_diff( GT_scanpaths_pp,scanpath );
        [ mean_distance_angle(sd), std_distance_angle(sd), distances_angle(sd,:) ] = pp_slanding( GT_scanpaths_pp, scanpath );
        if visualize
        superpos_sp=superpos_scanpath( img,scanpath,gazesnum,pxva,[ 0 1 0;1 0 0; 1 0 0; 0 0 0],false );
        imwrite2(superpos_sp,['figs' '/' 'scanpaths3' '/' 'decay' num2str(ior_decay) '/' model_name '_' imgname '_std_' num2str(ior_std_angle(sd))  '.png'],false);
        end
    end
    mean_samplitude_diff=mean_amplitude_diff_angle;
    mean_slanding=mean_distance_angle;
end
if visualize
plot(ior_std_angle,mean_amplitude_diff_angle);
plot(ior_std_angle,mean_distance_angle);
end



% if length(ior_std_angle)>1 && length(ior_decay)>1
%     for sd=1:length(ior_std_angle)
%         for d=1:length(ior_decay)
%             [scanpath,smaps,mean_smap]=staticsaliency2scanpath(smap,gazesnum,ior_decay(d),ior_peak,ior_std_angle(sd));
%             superpos_sp=superpos_scanpath( img,scanpath,gazesnum,pxva,[ 0 1 0;1 0 0; 1 0 0; 0 0 0],false );
%             imwrite2(superpos_sp,['figs' '/' 'scanpaths3' '/' model_name '_' imgname '_decay_' num2str(ior_decay(d))  '_std_' num2str(ior_std_angle(sd))  '.png'],false);
%         end
%     end
% end


end

