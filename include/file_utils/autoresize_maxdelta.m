function [ newimg ] = autoresize_maxdelta( img, n_scales, Delta,mida_min, max_Delta )
    if nargin < 5
        max_Delta=30;
    end
    scalemult=ceil(scale2size(1-(log2(32)-log2(mida_min)):n_scales-(log2(32)-log2(mida_min)),1,1.3));
    final_Delta_scaled=Delta*scalemult(end);
    
    ds=0;
    while final_Delta_scaled > max_Delta
        n_scales=n_scales-1;
        ds=ds+1;
        scalemult=ceil(scale2size(1-(log2(32)-log2(mida_min)):n_scales-(log2(32)-log2(mida_min)),1,1.3));
        final_Delta_scaled=scalemult(end);
    end
    
    
    newimg=autoresize(img,ds);
        
end

