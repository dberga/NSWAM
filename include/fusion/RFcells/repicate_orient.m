function [RF_s_o] = repicate_orient(RF_s, n_scales)
    RF_s_o = cell(n_scales-1,1);
    for s=1:n_scales-1
        for o=1:3
            RF_s_o{s}{o} = RF_s{s};
        end
    end
    %RF_s_o{n_scales} = RF_s{n_scales};
end

