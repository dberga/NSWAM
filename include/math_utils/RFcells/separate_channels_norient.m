    
function [c1_RF_s, c2_RF_s, c3_RF_s] = separate_channels_norient(RF_s_c, struct)
    
    c1_RF_s = cell(struct.wave.n_scales-1,1);
    c2_RF_s = cell(struct.wave.n_scales-1,1);
    c3_RF_s = cell(struct.wave.n_scales-1,1);
    
    for s=1:struct.wave.n_scales-1
            c1_RF_s{s}=RF_s_c{s}(:,:,1);
            c2_RF_s{s}=RF_s_c{s}(:,:,2);
            c3_RF_s{s}=RF_s_c{s}(:,:,3);
    end
    
end

    
