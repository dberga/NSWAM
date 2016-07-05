function rec = IDWD_orient_undecimated(w, c)

wlev    = length(c);
rec   = c{wlev,1};

for s = wlev:-1:1

    rec = rec + w{s,1}(:,:,1) + w{s,1}(:,:,2) + w{s,1}(:,:,3);    
    
end


end