function [ scanpath , smaps, mean_smap] = staticsaliency2scanpath(smap , gazesnum, ior_decay, ior_peak, ior_std_angle)

if nargin<5, 
    pxva=40; %pxva=rad2deg(0.6130); pxva=35.12;
    %ior_std_angle=6*(size(smap,1)./pxva); %itti
    ior_std_angle=pxva*3; 
end
if nargin<4, ior_peak=1; end
if nargin<3,ior_decay=0.9; end
if nargin<2, gazesnum=10; end

%decay constants (iters per tmem, tmems per gaze)
struct.zli_params.n_iter=10;
struct.zli_params.n_membr=10;
struct.gaze_params.ior_factor_ctt=ior_decay;

ior_matrix=zeros(size(smap,1),size(smap,2));
smap_tmp=smap;
smaps=smap_tmp;

for g=1:gazesnum
    [maxval,maxidx]=max(smap(:));
    [fov_y,fov_x]=ind2sub([size(smap,1) size(smap,2)],maxidx);
    bmap = scanpath2bmap([fov_x fov_y],[size(smap,1) size(smap,2)]);
    gaussian = ior_peak .* normalize_minmax(zhong2012(bmap,ior_std_angle));
    ior_matrix=get_ior_update( ior_matrix, struct ); %get_ior_factor(previous_inhibition,ior_factor_ctt)
    ior_matrix=ior_matrix+gaussian;
    %figure,imagesc(ior_matrix)
    smap=smap_tmp-ior_matrix;
    smap(smap<0)=0;
    smaps(:,:,g)=smap;
    %figure,imagesc(smap)
end

scanpath=smaps2scanpath(smaps);
mean_smap = get_smaps_mean(smaps);

%figure,imagesc(ior_matrix)
%figure,imagesc(mean_smap)


%figure,imagesc(superpos_scanpath( mean_smap,scanpath,gazesnum,pxva,[ 0 1 0;1 0 0; 1 0 0; 0 0 0],false )); %modified with ior

end

