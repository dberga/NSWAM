function [RF_s_c] = unify_channels_norient(c1_RF_s, c2_RF_s, c3_RF_s, struct)
    
    RF_s_c = cell(struct.wave_params.n_scales-1,1);
    for s=1:struct.wave_params.n_scales-1
            RF_s_c{s}(:,:,1)=c1_RF_s{s};
            RF_s_c{s}(:,:,2)=c2_RF_s{s};
            RF_s_c{s}(:,:,3)=c3_RF_s{s};
        
    end
    RF_s_c{struct.wave_params.n_scales-1}(:,:,1) = c1_RF_s{struct.wave_params.n_scales-1};
    RF_s_c{struct.wave_params.n_scales-1}(:,:,2) = c2_RF_s{struct.wave_params.n_scales-1};
    RF_s_c{struct.wave_params.n_scales-1}(:,:,3) = c3_RF_s{struct.wave_params.n_scales-1};
end

    
