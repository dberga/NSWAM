function [ deg ] = pix2deg( pix,  distance_monitor_cm, monitor_res_pix, monitor_cm  ) %only for one axis

    pix2deg = radtodeg(atan2(monitor_cm/2,distance_monitor_cm) / (monitor_res_pix/2));
    
    deg = pix*pix2deg;

end

