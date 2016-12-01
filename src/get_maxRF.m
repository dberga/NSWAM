function [RF_c_s_o,residual_c_s] = get_maxRF(loaded_struct,RF_s_o_c,residual_s_c)
        switch (loaded_struct.fusion_params.smethod)
            case 'pmax2'
                [RF_s,residual_s] = get_RF_max_t(RF_s_o_c,residual_s_c,loaded_struct);        
                RF_s_o = repicate_orient(RF_s,loaded_struct);
                %[RF_s_o_c{1},RF_s_o_c{2},RF_s_o_c{3}] = separate_channels(RF_s_o,loaded_struct);
                %[residual_s_c{1},residual_s_c{2},residual_s_c{3}] = separate_channels_norient(residual_s,loaded_struct);
                RF_c_s_o{1} = RF_s_o;
                RF_c_s_o{2} = RF_s_o;
                RF_c_s_o{3} = RF_s_o;
                
                %%max residual
                residual_c_s{1} = residual_s;
                residual_c_s{2} = residual_s;
                residual_c_s{3} = residual_s;
                
                %%same residual
                %residual_c_s = sc2cs(residual_s_c,loaded_struct.color_params.nchannels,loaded_struct.wave_params.n_scales);
                
            case 'pmaxc'
                [RF_s_o,residual_s] = get_RF_max_t_o(RF_s_o_c,residual_s_c,loaded_struct);  
                %[RF_s_o_c{1},RF_s_o_c{2},RF_s_o_c{3}] = separate_channels(RF_s_o,loaded_struct);
                %[residual_s_c{1},residual_s_c{2},residual_s_c{3}] = separate_channels_norient(residual_s,loaded_struct);
                
                RF_c_s_o{1} = RF_s_o;
                RF_c_s_o{2} = RF_s_o;
                RF_c_s_o{3} = RF_s_o;
                
                
                %%max residual
                residual_c_s{1} = residual_s;
                residual_c_s{2} = residual_s;
                residual_c_s{3} = residual_s;
                
                %%same residual
                %residual_c_s = sc2cs(residual_s_c,loaded_struct.color_params.nchannels,loaded_struct.wave_params.n_scales);

            otherwise
                RF_c_s_o = soc2cso(RF_s_o_c,loaded_struct.color_params.nchannels,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                residual_c_s = sc2cs(residual_s_c,loaded_struct.color_params.nchannels,loaded_struct.wave_params.n_scales);
                

        end
end
