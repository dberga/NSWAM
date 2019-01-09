function [ check ] = get_checksame( loaded_struct_path1,loaded_struct_path2 )
    struct1=load(loaded_struct_path1);
    struct2=load(loaded_struct_path2);
    
    
    %% do not compare these ones (not used or not relevant or overlapping)
    
    struct1.matrix_in.gaze_params.ngazes=0;struct2.matrix_in.gaze_params.ngazes=0;
    struct1.matrix_in.gaze_params.orig_width=0;struct2.matrix_in.gaze_params.orig_width=0;
    struct1.matrix_in.gaze_params.orig_height=0;struct2.matrix_in.gaze_params.orig_height=0;
    struct2.matrix_in.gaze_params.maxidx_s=0; struct1.matrix_in.gaze_params.maxidx_s=0;
    struct2.matrix_in.gaze_params.maxidx_o=0; struct1.matrix_in.gaze_params.maxidx_o=0;
    struct2.matrix_in.gaze_params.maxidx_c=0; struct1.matrix_in.gaze_params.maxidx_c=0;
    struct2.matrix_in.gaze_params.maxidx_x=0; struct1.matrix_in.gaze_params.maxidx_x=0;
    struct2.matrix_in.gaze_params.maxidx_y=0; struct1.matrix_in.gaze_params.maxidx_y=0;
    struct2.matrix_in.gaze_params.max_mempotential_val=0; struct1.matrix_in.gaze_params.max_mempotential_val=0;
    struct2.matrix_in.gaze_params.idx_max_mempotential_polarity=0; struct1.matrix_in.gaze_params.idx_max_mempotential_polarity=0;
    struct1.matrix_in.gaze_params.ior_matrix=0;struct2.matrix_in.gaze_params.ior_matrix=0;
    struct1.matrix_in.gaze_params.ior_matrix_multidim=0;struct2.matrix_in.gaze_params.ior_matrix_multidim=0;
    
    
    %struct1.matrix_in.gaze_params.fov_x=0; struct2.matrix_in.gaze_params.fov_x=0;
    %struct1.matrix_in.gaze_params.fov_y=0; struct2.matrix_in.gaze_params.fov_y=0;
    %struct1.matrix_in.gaze_params.gaze_idx=0;struct2.matrix_in.gaze_params.gaze_idx=0;
    
    %struct1.matrix_in.cortex_params.a=0; struct2.matrix_in.cortex_params.a=0;
    %struct1.matrix_in.cortex_params.b=0; struct2.matrix_in.cortex_params.b=0;
    
    if isfield(struct1.matrix_in,'search_params') || isfield(struct2.matrix_in,'search_params') 
        if struct1.matrix_in.search_params.topdown == 0 && struct2.matrix_in.search_params.topdown == 0
            struct1.matrix_in.search_params=0;
            struct2.matrix_in.search_params=0;
        end
    else
        struct1.matrix_in.search_params=0;
        struct2.matrix_in.search_params=0;
    end
    
    if struct1.matrix_in.gaze_params.foveate == 0 && struct2.matrix_in.gaze_params.foveate == 0
        struct1.matrix_in.gaze_params=0;
        struct2.matrix_in.gaze_params=0;
        struct1.matrix_in.cortex_params=0;
        struct2.matrix_in.cortex_params=0;
        struct1.matrix_in.wave_params.n_scales=struct2.matrix_in.wave_params.n_scales;
        struct1.matrix_in.wave_params.fin_scale=struct2.matrix_in.wave_params.fin_scale;
        
    else
        struct1.matrix_in.resize_params=0;
        struct2.matrix_in.resize_params=0;
        
        if struct1.matrix_in.gaze_params.ior == 0 && struct2.matrix_in.gaze_params.ior == 0
            struct1.matrix_in.gaze_params.ior_factor_ctt=0;
            struct2.matrix_in.gaze_params.ior_factor_ctt=0;
            struct1.matrix_in.gaze_params.ior_angle=0;
            struct2.matrix_in.gaze_params.ior_angle=0; 
            struct1.matrix_in.gaze_params.ior_diag_angle=0; 
            struct2.matrix_in.gaze_params.ior_angle=0; 
            struct1.matrix_in.gaze_params.ior_matrix=0;
            struct2.matrix_in.gaze_params.ior_matrix=0;
            struct1.matrix_in.gaze_params.ior_matrix_multidim=0;
            struct2.matrix_in.gaze_params.ior_matrix_multidim=0;
        end
        

        if ~isfield(struct1.matrix_in.gaze_params,'redistort_pertmem') && struct1.matrix_in.gaze_params.redistort_periter==0
                struct1.matrix_in.gaze_params.redistort_pertmem=0; 
        end
        if struct1.matrix_in.gaze_params.redistort_periter==1 && struct2.matrix_in.gaze_params.redistort_periter==0 && struct2.matrix_in.gaze_params.redistort_pertmem==1
                struct2.matrix_in.gaze_params.redistort_periter=1;
        end
    end
        
   
    
    %% check pre-dynamical parameters (compare if structs are equal)
    check=(isequal(struct1.matrix_in.color_params,struct2.matrix_in.color_params)...
        && isequal(struct1.matrix_in.wave_params,struct2.matrix_in.wave_params)...
        && isequal(struct1.matrix_in.zli_params,struct2.matrix_in.zli_params)...
        && isequal(struct1.matrix_in.cortex_params,struct2.matrix_in.cortex_params)...
        && isequal(struct1.matrix_in.gaze_params,struct2.matrix_in.gaze_params)...
        && isequal(struct1.matrix_in.search_params,struct2.matrix_in.search_params)...
        && isequal(struct1.matrix_in.compute_params.model,struct2.matrix_in.compute_params.model));
        %&& isequal(struct1.matrix_in.resize_params,struct2.matrix_in.resize_params)...
    
        
end

