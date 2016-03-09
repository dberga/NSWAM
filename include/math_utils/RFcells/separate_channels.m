    
function [c1_RF_s_o, c2_RF_s_o, c3_RF_s_o] = separate_channels(RF_s_o_c, struct)
    
    c1_RF_s_o = cell(struct.wave.n_scales,1);
    c2_RF_s_o = cell(struct.wave.n_scales,1);
    c3_RF_s_o = cell(struct.wave.n_scales,1);
    
    for s=1:struct.wave.n_scales-1
        for o=1:struct.wave.n_orient
            c1_RF_s_o{s}{o}=RF_s_o_c{s}{o}(:,:,1);
            c2_RF_s_o{s}{o}=RF_s_o_c{s}{o}(:,:,2);
            c3_RF_s_o{s}{o}=RF_s_o_c{s}{o}(:,:,3);
        end
    end
        c1_RF_s_o{struct.wave.n_scales} = RF_s_o_c{struct.wave.n_scales};
        c2_RF_s_o{struct.wave.n_scales} = RF_s_o_c{struct.wave.n_scales};
        c3_RF_s_o{struct.wave.n_scales} = RF_s_o_c{struct.wave.n_scales};
    
end

    
