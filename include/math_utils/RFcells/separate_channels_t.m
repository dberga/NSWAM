    
function [c1_RF_t_s_o, c2_RF_t_s_o, c3_RF_t_s_o] = separate_channels_t(RF_t_s_o_c, struct)
    
    c1_RF_t_s_o = cell(struct.zli.n_membr,1);
    c2_RF_t_s_o = cell(struct.zli.n_membr,1);
    c3_RF_t_s_o = cell(struct.zli.n_membr,1);
    for ff=1:struct.zli.n_membr
        for s=1:struct.wave.n_scales-1
            for o=1:struct.wave.n_orient
                c1_RF_t_s_o{ff}{s}{o}=RF_t_s_o_c{ff}{s}{o}(:,:,1);
                c1_RF_t_s_o{ff}{s}{o}=RF_t_s_o_c{ff}{s}{o}(:,:,2);
                c1_RF_t_s_o{ff}{s}{o}=RF_t_s_o_c{ff}{s}{o}(:,:,3);
            end
        end
        c1_RF_t_s_o{ff}{struct.wave.n_scales} = RF_t_s_o_c{ff}{struct.wave.n_scales};
        c2_RF_t_s_o{ff}{struct.wave.n_scales} = RF_t_s_o_c{ff}{struct.wave.n_scales};
        c3_RF_t_s_o{ff}{struct.wave.n_scales} = RF_t_s_o_c{ff}{struct.wave.n_scales};
    end
    
end

    
