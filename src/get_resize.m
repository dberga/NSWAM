function [input_image, new_fov_x, new_fov_y] = get_resize(input_image,conf_struct)
    if conf_struct.gaze_params.foveate == 0
        %resize functions
        if conf_struct.resize_params.autoresize_ds ~= -1    
            input_image = autoresize(input_image,conf_struct.resize_params.autoresize_ds);
        else
            input_image = autoresize(input_image);
        end
        if conf_struct.resize_params.autoresize_nd ~= 0
            input_image = autoresize_nd(input_image,conf_struct.zli_params.Delta,conf_struct.zli_params.reduccio_JW,conf_struct.resize_params.autoresize_nd);
        end
    end
            
end
