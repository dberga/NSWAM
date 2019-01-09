function [ multidim ] = normalize_channels( multidim )
    
    %minimums and maximums
    Lminmax=[0,3];
    aminmax=[-1,1];
    bminmax=[-2,1];
    
    %normalize to 0 and 1 for each corresponding channel
    multidim(:,:,:,:,1)=normalize_minmax(multidim(:,:,:,:,1),aminmax(1),aminmax(2));
    multidim(:,:,:,:,2)=normalize_minmax(multidim(:,:,:,:,2),bminmax(1),bminmax(2));
    multidim(:,:,:,:,3)=normalize_minmax(multidim(:,:,:,:,3),Lminmax(1),Lminmax(2));
    

    
    %normalize to -1 and 1
    multidim=normalize_spec(multidim,-1,1);
    
end

