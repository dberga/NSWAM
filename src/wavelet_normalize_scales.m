function [ w ] = wavelet_normalize_scales( w,factor )

for wlev=1:length(w)
    w{wlev}=w{wlev}.*factor(wlev);
end

end

