function [loaded_struct,conf_struct] = get_loaded_struct(run_flags,folder_props,image_props,mat_props,conf_struct,input_image,gaze_idx)
            
            %get scales, orientations
            [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(input_image, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
            [conf_struct.wave_params.n_orient] = calc_norient(input_image,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);

            %loaded struct from mats folder
            if run_flags.load_struct(gaze_idx)==1    
                [loaded_struct] = load(mat_props.loaded_struct_path{gaze_idx}); loaded_struct = loaded_struct.matrix_in;

                %for reconstruction, we can use post-calculation params
                loaded_struct.fusion_params = conf_struct.fusion_params;
                loaded_struct.csf_params = conf_struct.csf_params;
            else    
                [loaded_struct] = conf_struct;
                save_mat('struct',loaded_struct,folder_props,image_props,gaze_idx);
            end
            
end

