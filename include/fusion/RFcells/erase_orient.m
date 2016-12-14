function [RF_s] = erase_orient(RF_s_o, struct)
    RF_s = cell(struct.wave_params.n_scales,1);
    for s=1:struct.wave_params.n_scales-1
        
        %for o=1:3
            RF_s{s} = RF_s_o{s}{1};
        %end
    end
end