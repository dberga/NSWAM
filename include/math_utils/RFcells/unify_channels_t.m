function [RF_t_s_o_c] = unify_channels_t(c1_RF_t_s_o, c2_RF_t_s_o, c3_RF_t_s_o, struct)
    
    RF_t_s_o_c = cell(struct.zli.n_membr,1);
    for ff=1:struct.zli.n_membr
        for s=1:struct.wave.n_scales-1
            for o=1:struct.wave.n_orient
                RF_t_s_o_c{ff}{s}{o}(:,:,1)=c1_RF_t_s_o{ff}{s}{o};
                RF_t_s_o_c{ff}{s}{o}(:,:,2)=c2_RF_t_s_o{ff}{s}{o};
                RF_t_s_o_c{ff}{s}{o}(:,:,3)=c3_RF_t_s_o{ff}{s}{o};
            end
        end
        RF_t_s_o_c{ff}{struct.wave.n_scales}=c1_RF_t_s_o{ff}{struct.wave.n_scales};
        RF_t_s_o_c{ff}{struct.wave.n_scales}=c2_RF_t_s_o{ff}{struct.wave.n_scales};
        RF_t_s_o_c{ff}{struct.wave.n_scales}=c3_RF_t_s_o{ff}{struct.wave.n_scales};
    end
    
end
