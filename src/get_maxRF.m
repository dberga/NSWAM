function [RF_c_s_o,residual_c_s,max_s, max_o, max_c, max_x, max_y] = get_maxRF(loaded_struct,RF_s_o_c,residual_s_c)
        switch (loaded_struct.fusion_params.smethod)
            case 'pmax2'
                [RF_s,residual_s,max_s, max_o, max_c, max_x, max_y] = get_RF_max_t(RF_s_o_c,residual_s_c,3,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);        
                RF_s_o = repicate_orient(RF_s,loaded_struct.wave_params.n_scales);
                
                for c=1:3
                    RF_c_s_o{c} = RF_s_o;
                    residual_c_s{c} = residual_s;
                end
                

            case 'pmaxc'
                RF_c_s_o = soc2cso(RF_s_o_c,3,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                residual_c_s = sc2cs(residual_s_c,3,loaded_struct.wave_params.n_scales);
                
                for c=1:3
                    [RF_c_s_o{c},residual_c_s{c},max_s, max_o, max_c, max_x, max_y] = get_RF_max_t(RF_c_s_o{c},residual_c_s{c},1,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);        
                    RF_c_s_o{c} = repicate_orient(RF_c_s_o{c},loaded_struct.wave_params.n_scales);
                end
                
            otherwise
                
                RF_c_s_o = soc2cso(RF_s_o_c,3,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                residual_c_s = sc2cs(residual_s_c,3,loaded_struct.wave_params.n_scales);
                
                [~,~,max_s, max_o, max_c, max_x, max_y] = get_RF_max_t(RF_s_o_c,residual_s_c,3,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
        end
end
