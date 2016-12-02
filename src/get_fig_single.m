function [ ] = get_fig_single( input, name, folder_props,image_props, struct )

     
     imwrite(im2uint8(input),[folder_props.output_folder_figs '/' name '_gaze' num2str(struct.gaze_params.gaze_idx+1) '_' image_props.image_name_noext '.png']);

end

