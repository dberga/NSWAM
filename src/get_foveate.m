
function [input_image] = get_foveate(input_image,conf_struct)
    if conf_struct.gaze_params.foveate == 1
        input_image = foveate(input_image,0,conf_struct);
    end
end
