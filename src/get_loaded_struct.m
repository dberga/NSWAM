function [loaded_struct,conf_struct] = get_loaded_struct(run_flags,folder_props,image_props,mat_props,conf_struct,gaze_idx)
            
            
            
            %loaded struct from mats folder
            if run_flags.load_struct(gaze_idx)==1    
                [loaded_struct] = load(mat_props.loaded_struct_path{gaze_idx}); loaded_struct = loaded_struct.matrix_in;
            else    
                loaded_struct = conf_struct;
                save_mat('struct',loaded_struct,folder_props,image_props,gaze_idx);
            end
            
            conf_struct.wave_params=loaded_struct.wave_params;
            conf_struct.zli_params=loaded_struct.zli_params;
            conf_struct.cortex_params=loaded_struct.cortex_params;
            
            %for old configs, put default stuff here
            if ~isfield(conf_struct.gaze_params,'conserve_dynamics') conf_struct.gaze_params.conserve_dynamics = 1; end
            if ~isfield(conf_struct.gaze_params,'conserve_dynamics_rest') conf_struct.gaze_params.conserve_dynamics_rest = 1; end
            if ~isfield(conf_struct.gaze_params,'ior') conf_struct.gaze_params.ior = 0; end
            if ~isfield(conf_struct.gaze_params,'ior_matrix_multidim') conf_struct.gaze_params.ior_matrix_multidim = zeros(size(conf_struct.gaze_params.ior_matrix,1),size(conf_struct.gaze_params.ior_matrix,2),conf_struct.wave_params.n_scales-1,conf_struct.wave_params.n_orient,2,length(conf_struct.color_params.channels)); end
            if ~isfield(conf_struct.gaze_params,'ior_factor_ctt') conf_struct.gaze_params.ior_factor_ctt = 0; end
            if ~isfield(conf_struct.gaze_params,'redistort_pertmem') conf_struct.gaze_params.redistort_pertmem = 1; end
            if ~isfield(conf_struct.gaze_params,'redistort_periter')  conf_struct.gaze_params.redistort_periter = 0; end
            if ~isfield(conf_struct.gaze_params,'maxidx_s') conf_struct.gaze_params.maxidx_s = 1; end;
            if ~isfield(conf_struct.gaze_params,'maxidx_o') conf_struct.gaze_params.maxidx_o = 1; end;
            if ~isfield(conf_struct.gaze_params,'maxidx_c') conf_struct.gaze_params.maxidx_c = 1; end;
            if ~isfield(conf_struct.gaze_params,'maxidx_x') conf_struct.gaze_params.maxidx_x = 1; end;
            if ~isfield(conf_struct.gaze_params,'maxidx_y') conf_struct.gaze_params.maxidx_y = 1; end;
            if ~isfield(conf_struct.gaze_params,'max_mempotential_val') conf_struct.gaze_params.max_mempotential_val = 0; end;
            if ~isfield(conf_struct.gaze_params,'max_mempotential_polarity') conf_struct.gaze_params.max_mempotential_polarity = 1; end;
            if ~isfield(conf_struct.fusion_params,'gsp') conf_struct.fusion_params.gsp = 1; end;
            if ~isfield(conf_struct.fusion_params,'ior_smap') conf_struct.fusion_params.ior_smap = 1; end;
            if ~isfield(conf_struct.fusion_params,'inverse') conf_struct.fusion_params.inverse = 'multires_inv'; end;
            if ~isfield(conf_struct.compute_params,'posttune') conf_struct.compute_params.posttune=0; end

            %loaded struct gazing ovewrites
            loaded_struct.resize_params=conf_struct.resize_params;
            loaded_struct.gaze_params=conf_struct.gaze_params;
            loaded_struct.compute_params=conf_struct.compute_params;
            loaded_struct.fusion_params = conf_struct.fusion_params;
            
            
            
end

