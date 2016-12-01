function [smaps] = get_smaps(image_props,conf_struct)
    for k=1:conf_struct.gaze_params.ngazes
              smaps(:,:,k)=double(imread(image_props.output_image_paths{k})); 
    end

end
