function [loaded_struct,conf_struct] = get_loaded_struct(run_flags,folder_props,image_props,mat_props,conf_struct,gaze_idx)
            
            
            
            %loaded struct from mats folder
            if run_flags.load_struct(gaze_idx)==1    
                [loaded_struct] = load(mat_props.loaded_struct_path{gaze_idx}); loaded_struct = loaded_struct.matrix_in;
                
                
            else    
                loaded_struct = conf_struct;
                save_mat('struct',conf_struct,folder_props,image_props,gaze_idx);
            end
            
            conf_struct.gaze_params = loaded_struct.gaze_params;
            loaded_struct.fusion_params = conf_struct.fusion_params;
            loaded_struct.csf_params = conf_struct.csf_params;
            
            
end

