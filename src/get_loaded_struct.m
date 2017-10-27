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
            if ~isfield(loaded_struct.gaze_params,'maxidx_s') loaded_struct.gaze_params.maxidx_s = 1; end;
            if ~isfield(loaded_struct.gaze_params,'maxidx_o') loaded_struct.gaze_params.maxidx_o = 1; end;
            if ~isfield(loaded_struct.gaze_params,'maxidx_c') loaded_struct.gaze_params.maxidx_c = 1; end;
            if ~isfield(loaded_struct.gaze_params,'maxidx_x') loaded_struct.gaze_params.maxidx_x = 1; end;
            if ~isfield(loaded_struct.gaze_params,'maxidx_y') loaded_struct.gaze_params.maxidx_y = 1; end;
            if ~isfield(loaded_struct.gaze_params,'maxval') loaded_struct.gaze_params.maxval = 0; end;
            if ~isfield(loaded_struct.gaze_params,'redistort_pertmem')
                loaded_struct.gaze_params.redistort_pertmem=loaded_struct.gaze_params.redistort_periter;
            end
            
            %loaded struct gazing ovewrites
            loaded_struct.resize_params.M = conf_struct.resize_params.M;
            loaded_struct.resize_params.N = conf_struct.resize_params.N;
            conf_struct.resize_params = loaded_struct.resize_params;
            conf_struct.gaze_params = loaded_struct.gaze_params;
            
            %conf struct fusion ovewrites 
            loaded_struct.fusion_params = conf_struct.fusion_params;
            loaded_struct.csf_params = conf_struct.csf_params;
           
            %set default old params
            
            if ~isfield(loaded_struct.fusion_params,'gsp') loaded_struct.fusion_params.gsp = 1; end;
            if ~isfield(loaded_struct.fusion_params,'ior_smap') loaded_struct.fusion_params.ior_smap = 1; end;
            if ~isfield(loaded_struct.fusion_params,'inverse') loaded_struct.fusion_params.inverse = 'multires_inv'; end;
            if ~isfield(loaded_struct.compute_params,'posttune') loaded_struct.compute_params.posttune=0; end

            
end

