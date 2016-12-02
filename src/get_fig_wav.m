function [  ] = get_fig_wav( input, name, folder_props,image_props, struct )
    figure; [fig] = show_wav(input,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/' name '_gaze' num2str(struct.gaze_params.gaze_idx+1) '_' image_props.image_name_noext '.png']);
    close all;
end

