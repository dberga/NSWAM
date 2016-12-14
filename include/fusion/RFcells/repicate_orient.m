function [RF_s_o] = repicate_orient(RF_s, struct)
    RF_s_o = cell(struct.wave_params.n_scales,1);
    for s=1:struct.wave_params.n_scales-1
        for o=1:3
            RF_s_o{s}{o} = RF_s{s};
        end
    end
    RF_s_o{struct.wave_params.n_scales} = RF_s{struct.wave_params.n_scales};
end