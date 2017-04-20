function [smap,max_s,max_o,max_c] = get_fusion(RF_s_o_c, residual_s_c,loaded_struct)

    %get new format for IDWT
    RF_c_s_o = soc2cso(RF_s_o_c,3,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
    residual_c_s = sc2cs(residual_s_c,3,loaded_struct.wave_params.n_scales); 
    
    %get pointwise in all RF)
    [ RFmax, ~, max_s, max_o, max_c ] = get_wavet_max_t( RF_s_o_c, residual_s_c, loaded_struct.wave_params.n_scales, loaded_struct.wave_params.n_orient, 3 );
    
    %get pointwise in all RF, separate channels
    [ RFmax_c, ~, ~, ~, ~ ] = get_wavec_max_t( RF_s_o_c,residual_s_c,loaded_struct.wave_params.n_scales, loaded_struct.wave_params.n_orient,3 );
    
    %get pointwise prepared for IDWT
     switch (loaded_struct.fusion_params.smethod)
        case 'pmaxc'
            %get pointwise in all RF, separate scales and channels (replicate orient)
            [ RFmax_c_s_o{1},residualmax_c_s{1}, ~, ~, ~ ] = get_waves_max_t( RF_c_s_o{1},residual_c_s{1},loaded_struct.wave_params.n_scales, loaded_struct.wave_params.n_orient,1);
            [ RFmax_c_s_o{2},residualmax_c_s{2}, ~, ~, ~ ] = get_waves_max_t( RF_c_s_o{2},residual_c_s{2},loaded_struct.wave_params.n_scales, loaded_struct.wave_params.n_orient,1);
            [ RFmax_c_s_o{3},residualmax_c_s{3}, ~, ~, ~ ] = get_waves_max_t( RF_c_s_o{3},residual_c_s{3},loaded_struct.wave_params.n_scales, loaded_struct.wave_params.n_orient,1);

            RFmax_c_s_o{1} = repicate_orient(RFmax_c_s_o{1},loaded_struct.wave_params.n_scales);
            RFmax_c_s_o{2} = repicate_orient(RFmax_c_s_o{2},loaded_struct.wave_params.n_scales);
            RFmax_c_s_o{3} = repicate_orient(RFmax_c_s_o{3},loaded_struct.wave_params.n_scales);
            
            
         case 'pmax2'
            %get pointwise in all RF, separate scales (replicate orient)
            [ RFmax_c_s_o{1},residualmax_c_s{1}, ~, ~, ~ ]=get_waves_max_t( RF_s_o_c,residual_s_c,loaded_struct.wave_params.n_scales, loaded_struct.wave_params.n_orient,1 );
            RFmax_c_s_o{2} = RFmax_c_s_o{1};
            RFmax_c_s_o{3} = RFmax_c_s_o{1};
            residualmax_c_s{2}=residualmax_c_s{1};
            residualmax_c_s{3}=residualmax_c_s{1};
            
            RFmax_c_s_o{1} = repicate_orient(RFmax_c_s_o{1},loaded_struct.wave_params.n_scales);
            RFmax_c_s_o{2} = repicate_orient(RFmax_c_s_o{2},loaded_struct.wave_params.n_scales);
            RFmax_c_s_o{3} = repicate_orient(RFmax_c_s_o{3},loaded_struct.wave_params.n_scales);
            
         otherwise
             RFmax_c_s_o = RF_c_s_o;
             residualmax_c_s = residual_c_s;
     end
     RF_c_s_o = RFmax_c_s_o;
     residual_c_s = residualmax_c_s;
     
    
    if ~isfield(loaded_struct.fusion_params,'inverse') loaded_struct.fusion_params.inverse = 'multires_inv'; end
    switch loaded_struct.fusion_params.inverse
        case 'max'
            RF_c  = RFmax_c;
        otherwise

            RF_c_s_o{1} = so2s_o(RF_c_s_o{1},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            RF_c_s_o{2} = so2s_o(RF_c_s_o{2},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            RF_c_s_o{3} = so2s_o(RF_c_s_o{3},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            
            
            RF_c(:,:,1) = multires_inv_dispatcher(RF_c_s_o{1},residual_c_s{1},loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales-1,loaded_struct.wave_params.n_orient);
            RF_c(:,:,2) = multires_inv_dispatcher(RF_c_s_o{2},residual_c_s{2},loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales-1,loaded_struct.wave_params.n_orient);
            RF_c(:,:,3) = multires_inv_dispatcher(RF_c_s_o{3},residual_c_s{3},loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales-1,loaded_struct.wave_params.n_orient);
    end
        
             
            %from opponent to color (depending on flag)
            [RF_c] = get_opp2rgb(loaded_struct,RF_c);

            %combine channels
            [smap] = get_combine_channels(loaded_struct,RF_c);

            

end

