function [bmap] = get_smaps_bmap(scanpath,conf_struct)
    bmap = scanpath2bmap(scanpath,[conf_struct.gaze_params.orig_height conf_struct.gaze_params.orig_width]);
  
    
end
