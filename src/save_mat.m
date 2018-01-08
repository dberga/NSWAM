function [] = save_mat(mat_name,matrix_in,folder_props,image_props,gaze_idx,channel)
    if exist('channel','var') && exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_channel(' channel ')' '_gaze' num2str(gaze_idx) '.mat'];
    elseif exist('channel','var') && ~exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_channel(' channel ')' '.mat'];
    elseif ~exist('channel','var') && exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_gaze' num2str(gaze_idx) '.mat'];
    else
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '.mat'];
    end
    try
        mkdir(folder_props.output_folder_mats);
        save(mat_path,'matrix_in');
    catch
        try
            save([pwd '/' mat_path],'matrix_in');
        catch
            try
                save(mat_path,'matrix_in','-v7.3');
            catch
                try 
                    save([pwd '/' mat_path],'matrix_in','-v7.3');
                catch
                    try
                        save(['/home/media/dberga/DATA/repos/matlab' '/' mat_path],'matrix_in');
                    catch
                        save(['/home/davidb/neuro/matlab' '/' mat_path],'matrix_in');
                    end
                end
            end
        end
    end
end


