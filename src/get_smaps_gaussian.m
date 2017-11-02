function [gaussian_smap] = get_smaps_gaussian(scanpath,conf_struct)
    bmap = scanpath2bmap(scanpath, [conf_struct.gaze_params.orig_height conf_struct.gaze_params.orig_width]);
    params.pxva=radtodeg(conf_struct.gaze_params.img_diag_angle);
    gaussian_smap=uint8(255*bmap2dmap(double(bmap),2,params));
    
end



