
function [smap] = get_undistort(loaded_struct,smap,tofoveate)
            if nargin<3, tofoveate=loaded_struct.gaze_params.foveate; end
            
            if tofoveate == 1 || tofoveate == 3
                smap = foveate(smap,1,loaded_struct);
            end

end




