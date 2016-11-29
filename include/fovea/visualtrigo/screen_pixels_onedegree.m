function [ angle_diagonal_pix,  angle_vertical_pix, angle_horizontal_pix] = screen_pixels_onedegree( distance_monitor_cm, monitor_height_res_pix, monitor_height_cm, monitor_width_res_pix, monitor_width_cm )

    
    angle_vertical_pix = deg2pix(1,distance_monitor_cm,monitor_height_res_pix,monitor_height_cm);
    angle_horizontal_pix = deg2pix(1,distance_monitor_cm,monitor_width_res_pix,monitor_width_cm);
    angle_diagonal_pix = sqrt(angle_vertical_pix*angle_vertical_pix + angle_horizontal_pix*angle_horizontal_pix); 
        %same as considering deg2pix(1,distance_monitor_cm,sqrt(monitor_width_res_pix*monitor_width_res_pix+monitor_height_res_pix*monitor_height_res_pix),sqrt(monitor_width_cm*monitor_height_cm));
    
end

