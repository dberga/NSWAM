function [] = run_delete_files(folder_props,image_props,loaded_struct,gaze_idx)
    delete_files = loaded_struct.file_params.delete_mats; %delete mats after creating imgs (0=no, 1=yes)
    if delete_files == 1
        delete(get_mat_name('struct',folder_props,image_props,gaze_idx));
        delete(get_mat_name('iFactor',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{1}));
        delete(get_mat_name('iFactor',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2}));
        delete(get_mat_name('iFactor',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3}));
        delete(get_mat_name('w',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{1}));
        delete(get_mat_name('w',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2}));
        delete(get_mat_name('w',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3}));
        delete(get_mat_name('c',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{1}));
        delete(get_mat_name('c',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2}));
        delete(get_mat_name('c',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3}));

    end

end


