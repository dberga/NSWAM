function [ ] = test_ior( img_path, model_name,dataset_out_path, gazesnum, ior_decay,ior_peak,ior_std_angle )


if nargin <1, img_path=['input/111.png']; end
if nargin <2, model_name='no_cortical_config_b1_15_sqmean_fusion2_invdefault'; end %no_ior_config_15_b1_m12_after_sqmean_fusion2_invdefault
if nargin <3, dataset_out_path='output_tsotsos'; end
if nargin<5,ior_decay=[0.999]; end
% if nargin<5,ior_decay=[0.999 0.99 0.9 0.75 0]; end
if nargin<4, gazesnum=10; end
if nargin<6, ior_peak=1; end
    
[imgfolder,imgname,imgext]=fileparts(img_path);
img=double(imread(img_path))./255;
smap_path=[dataset_out_path '/' model_name '/' imgname '.png'];
smap=double(imread(smap_path))./255;

pxva=40; %pxva=rad2deg(0.6130); pxva=35.12;
if nargin<7, 
%     ior_std_angle=6*(size(smap,1)./pxva); %itti
%     ior_std_angle=pxva*6; 
    ior_std_angle=[pxva*1 pxva*2 pxva*3 pxva*4 pxva*5 pxva*6 pxva*7];
end

mkdir(['figs' '/scanpaths3']);

if length(ior_decay)>1 && length(ior_std_angle)<2
    mkdir(['figs' '/' 'scanpaths3' '/' 'std' num2str(ior_std_angle)]);
    for d=1:length(ior_decay)
        scanpath=round(staticsaliency2scanpath(smap,gazesnum,ior_decay(d),ior_peak,ior_std_angle));
        superpos_sp=superpos_scanpath( img,scanpath,gazesnum,pxva,[ 0 1 0;1 0 0; 1 0 0; 0 0 0],false );
        imwrite2(superpos_sp,['figs' '/' 'scanpaths3' '/' 'std' num2str(ior_std_angle) '/' model_name '_' imgname '_decay_' num2str(ior_decay(d))  '.png'],false);
    end
end

if length(ior_std_angle)>1 && length(ior_decay)<2
    mkdir(['figs' '/' 'scanpaths3' '/' 'decay' num2str(ior_decay)]);
    for sd=1:length(ior_std_angle)
        scanpath=round(staticsaliency2scanpath(smap,gazesnum,ior_decay,ior_peak,ior_std_angle(sd)));
        superpos_sp=superpos_scanpath( img,scanpath,gazesnum,pxva,[ 0 1 0;1 0 0; 1 0 0; 0 0 0],false );
        imwrite2(superpos_sp,['figs' '/' 'scanpaths3' '/' 'decay' num2str(ior_decay) '/' model_name '_' imgname '_std_' num2str(ior_std_angle(sd))  '.png'],false);
    end
end

if length(ior_std_angle)>1 && length(ior_decay)>1
    for sd=1:length(ior_std_angle)
        for d=1:length(ior_decay)
            scanpath=round(staticsaliency2scanpath(smap,gazesnum,ior_decay(d),ior_peak,ior_std_angle(sd)));
            superpos_sp=superpos_scanpath( img,scanpath,gazesnum,pxva,[ 0 1 0;1 0 0; 1 0 0; 0 0 0],false );
            imwrite2(superpos_sp,['figs' '/' 'scanpaths3' '/' model_name '_' imgname '_decay_' num2str(ior_decay(d))  '_std_' num2str(ior_std_angle(sd))  '.png'],false);
        end
    end
end

%compute SLanding and SAmplitude with GT 

end

