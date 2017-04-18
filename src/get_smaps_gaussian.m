function [gaussian_smap] = get_smaps_gaussian(scanpath,conf_struct)
    bmap = scanpath2bmap(scanpath, [conf_struct.gaze_params.orig_height conf_struct.gaze_params.orig_width]);
    if ~exist('conf_struct.gaze_params.dva','var'), conf_struct.gaze_params.dva=40;  end
    gaussian_smap = uint8(255*zhong2012(double(bmap),conf_struct.gaze_params.dva));  
    
end



