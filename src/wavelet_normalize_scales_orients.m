function [ w ] = wavelet_normalize_scales_orient( w,factor )

for wlev=1:length(w)
    for orient=1:size(w{wlev},3)
        w{wlev}(:,:,orient)=w{wlev}(:,:,orient).*factor(wlev,orient);
    end
end

end

