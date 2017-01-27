function [loaded_struct,conf_struct] = get_loaded_struct(run_flags,folder_props,image_props,mat_props,conf_struct,gaze_idx)
            
            
            
            %loaded struct from mats folder
            if run_flags.load_struct(gaze_idx)==1    
                [loaded_struct] = load(mat_props.loaded_struct_path{gaze_idx}); loaded_struct = loaded_struct.matrix_in;
                
                
            else    
                loaded_struct = conf_struct;
                save_mat('struct',conf_struct,folder_props,image_props,gaze_idx);
            end
            
            %for old configs, put default stuff here
            if ~isfield(loaded_struct.gaze_params,'conserve_dynamics') loaded_struct.gaze_params.conserve_dynamics = 0; end
            if ~isfield(loaded_struct.gaze_params,'conserve_dynamics_rest') loaded_struct.gaze_params.conserve_dynamics_rest = 0; end
            if ~isfield(loaded_struct.gaze_params,'ior') loaded_struct.gaze_params.ior = 0; end;
            if ~isfield(loaded_struct.gaze_params,'ior_factor_ctt') loaded_struct.gaze_params.ior_factor_ctt = 0; end;
            if ~isfield(loaded_struct.gaze_params,'ior_matrix') loaded_struct.gaze_params.ior_matrix = 0; end;
            
            %loaded struct gazing ovewrites
            loaded_struct.gaze_params.height = conf_struct.gaze_params.height;
            loaded_struct.gaze_params.width = conf_struct.gaze_params.width;
            conf_struct.gaze_params = loaded_struct.gaze_params;
            
            %conf struct fusion ovewrites 
            loaded_struct.fusion_params = conf_struct.fusion_params;
            loaded_struct.csf_params = conf_struct.csf_params;
            
            
            
            
end

