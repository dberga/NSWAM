function [ whitefactor,whitefactor2 ] = wavelet_whitefactor(  mida_min, n_scales )
    
    image_size=2^((n_scales-1)+(log(mida_min)/log(2))-1);
    whitenoise=imnoise(zeros(image_size),'gaussian',1);
    [w, c] = a_trous(whitenoise(:,:), n_scales-1);
    for wlev=1:length(w)
     deviation(wlev)=std(w{wlev}(:));
    end
    for wlev=1:length(w)
        for orient=1:size(w{wlev},3)
            wcoef=w{wlev}(:,:,orient);
            deviation_orient(wlev,orient)=std(wcoef(:));
        end 
        whitefactor2(wlev,:)=deviation_orient(wlev,1)./deviation_orient(wlev,:);
    end
    whitefactor=deviation(1)./deviation;   

    
end

