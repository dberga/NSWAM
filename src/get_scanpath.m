
function [scanpath] = get_scanpath(smaps,conf_struct)

        scanpath(1,2) = round(conf_struct.gaze_params.orig_height/2);
        scanpath(1,1) = round(conf_struct.gaze_params.orig_width/2);
           
        for k=1:conf_struct.gaze_params.ngazes
            smap = smaps(:,:,k);
            [maxval, maxidx] = max(smap(:));
            [conf_struct.gaze_params.fov_y, conf_struct.gaze_params.fov_x] = ind2sub(size(smap),maxidx); %x,y
                %cuidado con el size(smap), tiene que ser fov de imagen original
            scanpath(k+1,2) = conf_struct.gaze_params.fov_y;
            scanpath(k+1,1) = conf_struct.gaze_params.fov_x;
        end
    
end

