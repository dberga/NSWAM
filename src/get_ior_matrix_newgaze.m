function [ ior_matrix ] = get_ior_matrix_newgaze( ior_matrix, struct )
    
    %update current gaussian
    factor = 1;
    prec = 1/struct.zli_params.n_iter;
    for t=1:struct.zli_params.n_membr
        for iter=1:struct.zli_params.n_iter
                factor = factor.*exp(prec.*log(struct.gaze_params.ior_factor_ctt));
        end
    end
    ior_matrix = ior_matrix.*factor;
    
    %add new gaussian
    gaussian_inhibition = get_ior_gaussian(struct.gaze_params.fov_x, struct.gaze_params.fov_y, 1, struct.gaze_params.ior_angle, struct.gaze_params.orig_height, struct.gaze_params.orig_width, struct.gaze_params.img_diag_angle);
    
    ior_matrix = ior_matrix + gaussian_inhibition;
    
    

end

