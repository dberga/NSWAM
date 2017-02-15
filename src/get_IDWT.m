function [RF_c] = get_IDWT(loaded_struct,RF_c_s_o,residual_c_s)
        
        if ~exist('loaded_struct.fusion_params.inverse') loaded_struct.fusion_params.inverse = 'IDWT'; end
        switch loaded_struct.fusion_params.inverse
            case 'max'
                RF_c(:,:,1) = get_wave_max_t(RF_c_s_o{1},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                RF_c(:,:,2) = get_wave_max_t(RF_c_s_o{2},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                RF_c(:,:,3) = get_wave_max_t(RF_c_s_o{3},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            otherwise
                
                RF_c(:,:,1) = multires_inv_dispatcher(RF_c_s_o{1},residual_c_s{1},loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                RF_c(:,:,2) = multires_inv_dispatcher(RF_c_s_o{2},residual_c_s{2},loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                RF_c(:,:,3) = multires_inv_dispatcher(RF_c_s_o{3},residual_c_s{3},loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
        end
end
            