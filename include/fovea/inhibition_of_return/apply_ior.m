function [ out_map ] = apply_ior( map, time,iter, struct )
    %create parameters 
        %struct.gaze_params.ior_angle (rad)
        %struct.gaze_params.ior_factor_ctt (firing rate)
    
    inhibition_factor = get_ior_factor(time,struct.zli_params.n_membr,iter,struct.zli_params.n_iter,struct.gaze_params.ior_slope_ctt);
        %ior_factor_max = get_ior_factor(1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,struct.gaze_params.ior_slope_ctt);
        %ior_factor_min = get_ior_factor(struct.zli_params.n_membr,struct.zli_params.n_membr,struct.zli_params.n_iter,struct.zli_params.n_iter,struct.gaze_params.ior_slope_ctt);
        
    inhibition_gaussian = get_ior_gaussian(struct.gaze_params.fov_x, struct.gaze_params.fov_y, inhibition_factor, struct.gaze_params.ior_angle, struct.gaze_params.orig_height, struct.gaze_params.orig_width, struct.gaze_params.img_diag_angle);
        
    %inhibition = normalize_minmax(inhibition_gaussian); %function already normalizes
    
    inhibition= inhibition_gaussian  .* struct.gaze_params.ior_factor_ctt;
        
    out_map = map+inhibition;
    

end

