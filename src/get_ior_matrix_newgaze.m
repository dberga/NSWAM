function [ ior_matrix ] = get_ior_matrix_newgaze( ior_matrix,max_s,ini_s,fin_s, struct )
    
    %update current gaussian
    factor = 1;
    prec = 1/struct.zli_params.n_iter;
    for t=1:struct.zli_params.n_membr
        for iter=1:struct.zli_params.n_iter
                factor = factor.*exp(prec.*log(struct.gaze_params.ior_factor_ctt));
        end
    end
    ior_matrix = ior_matrix.*factor;
    
    %add new gaussian (with reescaled sigma upon winner scale)
    %ior_angle = struct.gaze_params.ior_angle / (2.^(max_s-1));
    %ior_angle = 2^(round(struct.wave_params.fin_scale/max_s));
    gaussian_inhibition = get_ior_gaussian(struct.gaze_params.fov_x, struct.gaze_params.fov_y, 1, max_s,ini_s,fin_s, struct.gaze_params.orig_height, struct.gaze_params.orig_width, struct.gaze_params.img_diag_angle);
    
    %sum gaussian to the current ior
    ior_matrix = ior_matrix + gaussian_inhibition;
    
    

end

