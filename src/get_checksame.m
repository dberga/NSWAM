function [ check ] = get_checksame( loaded_struct_path1,loaded_struct_path2 )
    struct1=load(loaded_struct_path1);
    struct2=load(loaded_struct_path2);
    
    
    %do not compare these ones (not used or not relevant)
    struct1.matrix_in.gaze_params.gaze_idx=0;
    struct2.matrix_in.gaze_params.gaze_idx=0;
    struct1.matrix_in.gaze_params.ngazes=0;
    struct2.matrix_in.gaze_params.ngazes=0;
    struct1.matrix_in.gaze_params.ior_angle=0;
    struct2.matrix_in.gaze_params.ior_angle=0; 
    struct1.matrix_in.gaze_params.orig_width=0;
    struct2.matrix_in.gaze_params.orig_width=0;
    struct1.matrix_in.gaze_params.orig_height=0;
    struct2.matrix_in.gaze_params.orig_height=0;
    
    if struct1.matrix_in.gaze_params.foveate == 0 && struct2.matrix_in.gaze_params.foveate == 0
        struct1.matrix_in.gaze_params=0;
        struct2.matrix_in.gaze_params=0;
    else
        struct1.matrix_in.resize_params=0;
        struct2.matrix_in.resize_params=0;
    end
        
   if struct1.matrix_in.gaze_params.ior == 0 && struct2.matrix_in.gaze_params.ior == 0
       %do not compare these ones
        struct1.matrix_in.gaze_params.ior_factor_ctt=0;
        struct2.matrix_in.gaze_params.ior_factor_ctt=0;
        struct1.matrix_in.gaze_params.ior_matrix=0;
        struct2.matrix_in.gaze_params.ior_matrix=0;
   end
    
    
    
    %check pre-dynamical parameters (compare if structs are equal)
    check=(isequal(struct1.matrix_in.color_params,struct2.matrix_in.color_params)...
        && isequal(struct1.matrix_in.wave_params,struct2.matrix_in.wave_params)...
        && isequal(struct1.matrix_in.zli_params,struct2.matrix_in.zli_params)...
        && isequal(struct1.matrix_in.resize_params,struct2.matrix_in.resize_params)...
        && isequal(struct1.matrix_in.cortex_params,struct2.matrix_in.cortex_params)...
        && isequal(struct1.matrix_in.gaze_params,struct2.matrix_in.gaze_params));
    
        
end

