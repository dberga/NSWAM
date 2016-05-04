
        
function [smap] = RF_to_smap_t(RF_s_o_c,residual_s_c,Ls_s_c,struct)

    %1. compute ecsf (RF_s_o_c -> RF_s_o_c)
    %2. compute pmax2 (RF_s_o_c -> RF_s)
    %3. compute IDWT (RF_s -> RF)
    %4. compute Z (RF -> RF)
    
    
    %compute eCSF
    if strcmp(struct.compute.output_from_csf,'eCSF') == 1
        [RF_s_o_c] = apply_eCSF_percanal(RF_s_o_c, struct);
    end
    
    %inverse decomposition or max then inverse decomposition
    switch (struct.compute.smethod)
        case 'pmax2'
            [RF_s,residual_s,Ls_s] = get_RF_max_t(RF_s_o_c,residual_s_c,Ls_s_c,struct);        
            RF_s_o = repicate_orient(RF_s,struct);
            
            %despues de maximos solo hay un canal que copiar y reconstruir, que son los maximos
            RF_c(:,:,1) = RF_to_rec_channel_t(RF_s_o,residual_s,Ls_s,struct); 
            RF_c(:,:,2) = RF_c(:,:,1);
            RF_c(:,:,3) = RF_c(:,:,1);
        
        case 'pmaxc'
            [RF_s_o,residual_s,Ls_s] = get_RF_max_t_o(RF_s_o_c,residual_s_c,Ls_s_c,struct);   
            
            %despues de maximos solo hay un canal, que son los maximos
            RF_c(:,:,1) = RF_to_rec_channel_t(RF_s_o,residual_s,Ls_s,struct); 
            RF_c(:,:,2) = RF_c(:,:,1);
            RF_c(:,:,3) = RF_c(:,:,1);
        otherwise
            
            [c1_RF_s_o,c2_RF_s_o,c3_RF_s_o] = separate_channels(RF_s_o_c,struct);
            [c1_residual_s,c2_residual_s,c3_residual_s] = separate_channels_norient(residual_s_c,struct);
            [c1_Ls_s,c2_Ls_s,c3_Ls_s] = separate_channels_norient(Ls_s_c,struct);
            
            for s=1:struct.wave.n_scales-1
            for o=1:struct.wave.n_orient
                RF_c(:,:,1) = RF_to_rec_channel_t(c1_RF_s_o,c1_residual_s,c1_Ls_s,struct);
                RF_c(:,:,2) = RF_to_rec_channel_t(c2_RF_s_o,c2_residual_s,c2_Ls_s,struct);
                RF_c(:,:,3) = RF_to_rec_channel_t(c3_RF_s_o,c3_residual_s,c3_Ls_s,struct);
            end
            end
    end
    
    
    %from opponent to color (no)
    if struct.compute.orgb_flag == 1  
		RF_c = get_the_ostimulus(RF_c,struct.image.gamma,struct.image.srgb_flag);
    end 
    
    
    %combine channels
	switch (struct.compute.smethod)
        case 'pmax2'
            smap = RF_c(:,:,1); %max opp i orient, los tres canales lo mismo
        case 'wta' 
       		smap = channelwta(RF_c); %guanya nomes canal amb mes energia
		case 'pmax'  
      
        	smap = channelmax(RF_c);	%maxim canals, despres de recons.
        case 'pmaxc'
      
        	smap = RF_c(:,:,1); %maxim opp, los tres canales lo mismo
		case 'sqmean'
        	smap = channelsqmean(RF_c);
        otherwise
            smap = channelsqmean(RF_c);
    end


    
    %normalize according to a specific type (Z, energy ...)
    switch(struct.compute.fusion)
		case 1	
	
			  smap = normalize_energy(smap);

		case 2

			  smap = normalize_Z(smap);
        case 3
            
            smap = normalize_minmax(smap);
        case 4
            smap = normalize_energy(smap);
            smap = normalize_minmax(smap);
    
        case 5
            smap = normalize_Z(smap);
            smap = normalize_minmax(smap);
    
		otherwise
			%do nothing
    end
    
    %undistort
    if struct.image.foveate == 1
        smap = foveate(smap,struct,1);
    end

	%space to uint8
    smap = smap*255;
	smap = uint8(smap);
    
    

end








