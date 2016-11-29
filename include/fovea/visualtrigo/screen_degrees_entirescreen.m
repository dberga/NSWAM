function [ angle_diagonal,  angle_vertical, angle_horizontal] = screen_degrees_entirescreen(M,N, distance_monitor_cm, monitor_height_res_pix, monitor_height_cm, monitor_width_res_pix, monitor_width_cm )
    
    [angle_diagonal_pix,  angle_vertical_pix, angle_horizontal_pix] = screen_pixels_onedegree(distance_monitor_cm, monitor_height_res_pix, monitor_height_cm, monitor_width_res_pix, monitor_width_cm);
    
    img_diag_pix=sqrt(M*M+N*N);

    angle_horizontal = N/angle_horizontal_pix;
    angle_vertical = M/angle_vertical_pix;
    angle_diagonal = img_diag_pix/angle_diagonal_pix;
    
    
    
end

