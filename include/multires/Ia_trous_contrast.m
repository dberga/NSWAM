function rec = Ia_trous_contrast(w, c)

wlev    = length(c);
rec   = c{wlev,1};

for s = wlev:-1:1

%     rec = rec + w{s,1}(:,:,1) + w{s,1}(:,:,2) + w{s,1}(:,:,3);    

	     % add wavelet plane information to blurred residual:
    c = w{s,1}(:,:,1) + w{s,1}(:,:,2) + w{s,1}(:,:,3);
	 rec = rec .* (1+c)./(1-c);

end


end