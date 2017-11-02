function [gaussian_smap] = get_smaps_gaussian(scanpath,conf_struct)
    bmap = scanpath2bmap(scanpath, [conf_struct.gaze_params.orig_height conf_struct.gaze_params.orig_width]);
    params.pxva=radtodeg(conf_struct.gaze_params.img_diag_angle);
    
    if ~isfield(conf_struct.fusion_params,'gaussian_option') conf_struct.fusion_params.gaussian_option = 2; end
    
    gaussian_smap=uint8(255*bmap2dmap(double(bmap),conf_struct.fusion_params.gaussian_option,params));
    
end



