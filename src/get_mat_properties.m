function [mat_props] = get_mat_properties(folder_props,image_props,conf_struct)

    mat_props.loaded_struct_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op1_iFactor_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op2_iFactor_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op3_iFactor_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op1_WavCurv_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op2_WavCurv_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op3_WavCurv_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op1_WavResidual_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op2_WavResidual_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op3_WavResidual_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op1_xon_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op2_xon_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op3_xon_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op1_yon_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op2_yon_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op3_yon_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op1_xoff_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op2_xoff_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op3_xoff_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op1_yoff_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op2_yoff_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op3_yoff_path = cell(1,conf_struct.gaze_params.ngazes);
    
    for k=1:conf_struct.gaze_params.ngazes
        
        mat_props.loaded_struct_path{k} = get_mat_name('struct',folder_props,image_props,k);
        
        mat_props.op1_iFactor_path{k} = get_mat_name('iFactor',folder_props,image_props,k,'chromatic');
        mat_props.op2_iFactor_path{k} = get_mat_name('iFactor',folder_props,image_props,k,'chromatic2');
        mat_props.op3_iFactor_path{k} = get_mat_name('iFactor',folder_props,image_props,k,'intensity');
        
        mat_props.op1_xon_path{k} = get_mat_name('xon',folder_props,image_props,k,'chromatic');
        mat_props.op2_xon_path{k} = get_mat_name('xon',folder_props,image_props,k,'chromatic2');
        mat_props.op3_xon_path{k} = get_mat_name('xon',folder_props,image_props,k,'intensity');
        
        mat_props.op1_yon_path{k} = get_mat_name('yon',folder_props,image_props,k,'chromatic');
        mat_props.op2_yon_path{k} = get_mat_name('yon',folder_props,image_props,k,'chromatic2');
        mat_props.op3_yon_path{k} = get_mat_name('yon',folder_props,image_props,k,'intensity');
        
        mat_props.op1_xoff_path{k} = get_mat_name('xoff',folder_props,image_props,k,'chromatic');
        mat_props.op2_xoff_path{k} = get_mat_name('xoff',folder_props,image_props,k,'chromatic2');
        mat_props.op3_xoff_path{k} = get_mat_name('xoff',folder_props,image_props,k,'intensity');
        
        mat_props.op1_yoff_path{k} = get_mat_name('yoff',folder_props,image_props,k,'chromatic');
        mat_props.op2_yoff_path{k} = get_mat_name('yoff',folder_props,image_props,k,'chromatic2');
        mat_props.op3_yoff_path{k} = get_mat_name('yoff',folder_props,image_props,k,'intensity');
        
        mat_props.op1_WavCurv_path{k} = get_mat_name('w',folder_props,image_props,k,'chromatic');
        mat_props.op2_WavCurv_path{k} = get_mat_name('w',folder_props,image_props,k,'chromatic2');
        mat_props.op3_WavCurv_path{k} = get_mat_name('w',folder_props,image_props,k,'intensity');
        
        mat_props.op1_WavResidual_path{k} = get_mat_name('c',folder_props,image_props,k,'chromatic');
        mat_props.op2_WavResidual_path{k} = get_mat_name('c',folder_props,image_props,k,'chromatic2');
        mat_props.op3_WavResidual_path{k} = get_mat_name('c',folder_props,image_props,k,'intensity');
        
        
    end
end



