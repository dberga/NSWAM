
function [input_image] = get_foveate(input_image,conf_struct,tofoveate)
    if nargin<3, tofoveate=conf_struct.gaze_params.foveate; end
    
    if tofoveate == 1
        input_image = foveate(input_image,0,conf_struct);
    end
end
