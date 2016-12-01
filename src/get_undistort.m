
function [smap] = get_undistort(loaded_struct,smap)
            if loaded_struct.gaze_params.foveate == 1
                smap = foveate(smap,1,loaded_struct);
            end

end




