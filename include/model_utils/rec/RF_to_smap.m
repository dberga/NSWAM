
function [smap] = RF_to_smap(c1_RF,c1_residual,c1_Ls,c2_RF,c2_residual,c2_Ls,c3_RF,c3_residual,c3_Ls,struct)


if strcmp(struct.compute.smethod,'pmax2')==1
	
	
	n_scales =  struct.wave.n_scales;
	n_membr = struct.zli.n_membr;
	%method = struct.wave.multires;
	
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

	

    
    
	

else
	%reconstruct opponent channels (IDWT)

	c1_RF_rec = RF_to_rec_channel(c1_RF,c1_residual,c1_Ls,struct);
	c2_RF_rec = RF_to_rec_channel(c2_RF,c2_residual,c2_Ls,struct);
	c3_RF_rec = RF_to_rec_channel(c3_RF,c3_residual,c3_Ls,struct);
	RF_rec(:,:,1,:) = c1_RF_rec;
	RF_rec(:,:,2,:) = c2_RF_rec;
	RF_rec(:,:,3,:) = c3_RF_rec;

	


end
    %make temporal mean
    if strcmp(struct.compute.tmem_res,'max') == 1
        RF_recmean = static_computeframesmax(RF_rec,struct.zli.n_membr,struct.zli.n_frames_promig);
    else
        RF_recmean = static_computeframesmean(RF_rec,struct.zli.n_membr,struct.zli.n_frames_promig);
    end
    
    
    
    %from opponent to color (no)
    if struct.image.orgb_flag == 1  
		RF_recmean = get_the_ostimulus(RF_recmean,struct.image.gamma,struct.image.srgb_flag);
    end
    

        %1=normalize each channel with respect to energy (per repartir)
	%2=normalize each channel with respect to zli's (value - mean)/stdev
	switch(struct.image.fusion)
		case 1	
			normalized_color_smap = zeros(size(RF_recmean,1),size(RF_recmean,2));
			for op=1:3 %for each opponent channel, normalize with respect to sum value
			  normalized_color_smap(:,:,op) = normalize_channel(RF_recmean(:,:,op));
			end
		case 2
			normalized_color_smap = zeros(size(RF_recmean,1),size(RF_recmean,2));
			for op=1:3 %for each opponent channel, normalize with respect to sum value
			  normalized_color_smap(:,:,op) = normalize_channel2(RF_recmean(:,:,op));
			end
		otherwise
			normalized_color_smap = RF_recmean;
	end
    

	%combine channels
	switch (struct.compute.smethod)
		case 'wta'
			smap = channelwta(normalized_color_smap);
		case 'pmax'
			smap = channelmax(normalized_color_smap);	
		case 'sqmean'
			smap = channelsqmean(normalized_color_smap);
        case 'pmax2'
            smap = normalized_color_smap(:,:,1);
		otherwise
			smap = channelsqmean(normalized_color_smap);
	end

	%normalize final map with respect to max values
	normalized_smap = normalize_map(smap);
	smap = normalized_smap;
	smap = uint8(smap);

end





