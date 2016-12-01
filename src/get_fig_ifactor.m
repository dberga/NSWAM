function [  ] = get_fig_ifactor( input, name, folder_props,image_props, struct )
    [figs] = show_RF_dynamic(input,1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    for f=1:numel(figs)
        fig = figs(f);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/'  name '_' int2str(f) '_gaze' num2str(struct.gaze_params.gaze_idx)  '_' image_props.image_name_noext '.png']);
    end
    close all;
end

