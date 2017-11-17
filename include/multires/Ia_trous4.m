function rec = Ia_trous4(w, c)

wlev    = length(c);
rec   = c{wlev};

for s = wlev:-1:1
    
    rec = rec + w{s,1}(:,:,1) + w{s,1}(:,:,2) + w{s,1}(:,:,3) + + w{s,1}(:,:,4); 
    
end

end