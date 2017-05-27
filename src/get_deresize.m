function [smap] = get_deresize(loaded_struct,smap)
%     if loaded_struct.resize_params.autoresize_ds ~= 0 || loaded_struct.resize_params.autoresize_nd ~=0
        smap = imresize(smap,[loaded_struct.gaze_params.orig_height loaded_struct.gaze_params.orig_width]);
%     end

end
