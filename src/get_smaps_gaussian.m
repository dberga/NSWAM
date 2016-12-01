function [gaussian_smap] = get_smaps_gaussian(scanpath,conf_struct)
    bmap = scanpath2bmap(scanpath, size(scanpath,1),[conf_struct.gaze_params.orig_height conf_struct.gaze_params.orig_width]);
    gaussian_smap = bmap2gaussian(bmap);
    gaussian_smap = normalize_minmax(gaussian_smap);   
    
end



