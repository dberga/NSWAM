function [input_image] = get_resize(input_image,conf_struct)

    if conf_struct.gaze_params.foveate == 0 || conf_struct.gaze_params.foveate == 3

         n_scales=calc_scales(input_image, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires);
         if conf_struct.zli_params.bScaleDelta==1
                 [ input_image ] = autoresize_maxdelta( input_image, n_scales,conf_struct.zli_params.Delta, conf_struct.wave_params.mida_min  );
         end
        
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
