function [RF_s_o_c] = unify_channels(c1_RF_s_o, c2_RF_s_o, c3_RF_s_o, struct)
    
    RF_s_o_c = cell(struct.wave_params.n_scales,1);
    for s=1:struct.wave_params.n_scales-1
        for o=1:struct.wave_params.n_orient
            RF_s_o_c{s}{o}(:,:,1)=c1_RF_s_o{s}{o};
            RF_s_o_c{s}{o}(:,:,2)=c2_RF_s_o{s}{o};
            RF_s_o_c{s}{o}(:,:,3)=c3_RF_s_o{s}{o};
        end
    end
        RF_s_o_c{struct.wave_params.n_scales}=c1_RF_s_o{struct.wave_params.n_scales};
        RF_s_o_c{struct.wave_params.n_scales}=c2_RF_s_o{struct.wave_params.n_scales};
        RF_s_o_c{struct.wave_params.n_scales}=c3_RF_s_o{struct.wave_params.n_scales};
end

    
