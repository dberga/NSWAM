function [RF_t_s_o_c] = unify_channels_t(c1_RF_t_s_o, c2_RF_t_s_o, c3_RF_t_s_o, struct)
    
    RF_t_s_o_c = cell(struct.zli_params.n_membr,1);
    for ff=1:struct.zli_params.n_membr
        for s=1:struct.wave_params.n_scales-1
            for o=1:struct.wave_params.n_orient
                RF_t_s_o_c{ff}{s}{o}(:,:,1)=c1_RF_t_s_o{ff}{s}{o};
                RF_t_s_o_c{ff}{s}{o}(:,:,2)=c2_RF_t_s_o{ff}{s}{o};
                RF_t_s_o_c{ff}{s}{o}(:,:,3)=c3_RF_t_s_o{ff}{s}{o};
            end
        end
    end
    
end
