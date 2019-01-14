function [ scanpath ] = staticsaliency2scanpath( smap , gazesnum)

if nargin<2, gazesnum=10; end
pxva=40;
ior_decay=0.9;
ior_peak=1; %normalize to 1
ior_std_angle=pxva*3;
ior_matrix=zeros(size(smap,1),size(smap,2));
smap_tmp=smap;
smaps=smap_tmp;

for g=1:gazesnum
    [maxval,maxidx]=max(smap(:));
    [fov_y,fov_x]=ind2sub([size(smap,1) size(smap,2)],maxidx);
    bmap = scanpath2bmap([fov_x fov_y],[size(smap,1) size(smap,2)]);
    gaussian = ior_peak .* normalize_minmax(zhong2012(bmap,ior_std_angle));
    ior_matrix=ior_matrix+gaussian;
    smap=smap_tmp-ior_matrix;
    smap(smap<0)=0;
    %aplicar el decay aqui
    smaps(:,:,g)=smap;
end
mean_smap = get_smaps_mean(smaps);

figure,imagesc(ior_matrix)
figure,imagesc(smap)
figure,imagesc(mean_smap)

end

