
function [smap] = RF_to_smap(c1_RF,c1_residual,c1_Ls,c2_RF,c2_residual,c2_Ls,c3_RF,c3_residual,c3_Ls,struct);


if strcmp(struct.compute.smethod,'pmax2')==1
	
	
	n_scales =  struct.wave.n_scales;
	n_membr = struct.zli.n_membr;
	method = struct.wave.multires;
	
	allmax_RF = c1_RF;
	allresidual_RF = c1_residual;


	
	for ff=1:n_membr
		for s=1:n_scales-1
		    [RFmax, RFresidual] = get_RF_max(c1_RF,c1_residual,c1_Ls,c2_RF,c2_residual,c2_Ls,c3_RF,c3_residual,c3_Ls,struct,ff,s);
		    allmax_RF{ff}{s}{1} = RFmax;
            allmax_RF{ff}{s}{2} = RFmax;
            allmax_RF{ff}{s}{3} = RFmax;
		    allresidual_RF{s} = RFresidual;
		end
	end


	%reconstruct opponent channels (IDWT)
    all_RF_rec = RF_to_rec_channel(allmax_RF,allresidual_RF,c1_Ls,struct);
	RF_rec(:,:,1,:) = all_RF_rec;
	RF_rec(:,:,2,:) = all_RF_rec;
	RF_rec(:,:,3,:) = all_RF_rec;

	%make temporal mean
	RF_recmean = static_computeframesmean(RF_rec,struct.zli.n_membr,struct.zli.n_frames_promig);
      	smap = RF_recmean(:,:,1);

	%normalize with respect to energy

	smap = normalize_channel(smap);
	
	%normalize final map with respect to max values

	normalized_smap = normalize_map(smap);
	smap = normalized_smap;
	smap = uint8(smap);

else
	%reconstruct opponent channels (IDWT)

	c1_RF_rec = RF_to_rec_channel(c1_RF,c1_residual,c1_Ls,struct);
	c2_RF_rec = RF_to_rec_channel(c2_RF,c2_residual,c2_Ls,struct);
	c3_RF_rec = RF_to_rec_channel(c3_RF,c3_residual,c3_Ls,struct);
	RF_rec(:,:,1,:) = c1_RF_rec;
	RF_rec(:,:,2,:) = c2_RF_rec;
	RF_rec(:,:,3,:) = c3_RF_rec;

	%make temporal mean

	RF_recmean = static_computeframesmean(RF_rec,struct.zli.n_membr,struct.zli.n_frames_promig);

	%from opponent to color (no)

		%%RF_recmean = get_the_ostimulus(RF_recmean,struct.image.gamma,struct.image.srgb_flag);
	    
	%normalize each channel with respect to energy

	normalized_color_smap = zeros(size(RF_recmean,1),size(RF_recmean,2));
	for op=1:3 %for each opponent channel, normalize with respect to sum value
	  normalized_color_smap(:,:,op) = normalize_channel(RF_recmean(:,:,op));
	end

	%combine channels
	switch (struct.compute.smethod)
		case 'wta'
			smap = channelwta(normalized_color_smap);
		case 'pmax'
			smap = channelmax(normalized_color_smap);	
		case 'sqmean'
			smap = channelsqmean(normalized_color_smap);
		otherwise
			smap = channelsqmean(normalized_color_smap);
	end

	%normalize final map with respect to max values
	normalized_smap = normalize_map(smap);
	smap = normalized_smap;
	smap = uint8(smap);

end




end
