function [mat_path] = get_mat_name(mat_name,folder_props,image_props,gaze_idx,channel)
    if exist('channel','var') && exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_channel(' channel ')' '_gaze' num2str(gaze_idx) '.mat'];
    elseif exist('channel','var') && ~exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_channel(' channel ')' '.mat'];
    elseif ~exist('channel','var') && exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_gaze' num2str(gaze_idx) '.mat'];
    else
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '.mat'];
    end
end

