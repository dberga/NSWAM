function [ check ] = get_checksame( loaded_struct_path1,loaded_struct_path2 )
    struct1=load(loaded_struct_path1);
    struct2=load(loaded_struct_path2);
    
    %might be different gazes, as long as fov_x,fov_y is same
    struct1.matrix_in.gaze_params.gaze_idx=0;
    struct2.matrix_in.gaze_params.gaze_idx=0;
    
    %check pre-dynamical parameters
    check=(isequal(struct1.matrix_in.color_params,struct2.matrix_in.color_params)...
        && isequal(struct1.matrix_in.wave_params,struct2.matrix_in.wave_params)...
        && isequal(struct1.matrix_in.zli_params,struct2.matrix_in.zli_params)...
        && isequal(struct1.matrix_in.resize_params,struct2.matrix_in.resize_params)...
        && isequal(struct1.matrix_in.gaze_params,struct2.matrix_in.gaze_params)...
        && isequal(struct1.matrix_in.cortex_params,struct2.matrix_in.cortex_params));
    
end

