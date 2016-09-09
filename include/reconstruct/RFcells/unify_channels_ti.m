function [RF_t_s_o_c] = unify_channels_ti(c1_RF_ti_s_o, c2_RF_ti_s_o, c3_RF_ti_s_o, struct)
    
    RF_t_s_o_c = cell(struct.zli_params.n_membr,1);
    for ff=1:struct.zli_params.n_membr
        for it=1:struct.zli_params.n_iter
            for s=1:struct.wave_params.n_scales-1
                for o=1:struct.wave_params.n_orient
                    RF_t_s_o_c{ff}{it}{s}{o}(:,:,1)=c1_RF_ti_s_o{ff}{it}{s}{o};
                    RF_t_s_o_c{ff}{it}{s}{o}(:,:,2)=c2_RF_ti_s_o{ff}{it}{s}{o};
                    RF_t_s_o_c{ff}{it}{s}{o}(:,:,3)=c3_RF_ti_s_o{ff}{it}{s}{o};
                end
            end
            %RF_t_s_o_c{ff}{it}{struct.wave_params.n_scales}=c1_RF_ti_s_o{ff}{it}{struct.wave_params.n_scales};
            %RF_t_s_o_c{ff}{it}{struct.wave_params.n_scales}=c2_RF_ti_s_o{ff}{it}{struct.wave_params.n_scales};
            %RF_t_s_o_c{ff}{it}{struct.wave_params.n_scales}=c3_RF_ti_s_o{ff}{it}{struct.wave_params.n_scales};
        end
    end
    
end
