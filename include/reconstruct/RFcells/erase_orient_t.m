

function [RF_t_s] = erase_orient_t(RF_t_s_o, struct)
    RF_t_s = cell(struct.zli_params.n_membr,1);
    for ff=1:struct.zli_params.n_membr
    for s=1:struct.wave_params.n_scales-1
        %for o=1:3
            RF_t_s{ff}{s} = RF_t_s_o{ff}{s}{1};
        %end
    end
    end
end