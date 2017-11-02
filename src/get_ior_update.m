function [ ior_matrix ] = get_ior_update( ior_matrix, struct )
    
    %update current gaussian
    factor = 1;
    prec = 1/struct.zli_params.n_iter;
    for t=1:struct.zli_params.n_membr
        for iter=1:struct.zli_params.n_iter
                factor = factor.*exp(prec.*log(struct.gaze_params.ior_factor_ctt));
        end
    end
    ior_matrix = ior_matrix.*factor;
    

end

