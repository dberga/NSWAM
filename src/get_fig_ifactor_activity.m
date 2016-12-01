function [  ] = get_fig_ifactor_activity(  input, name, folder_props,image_props, struct )
    [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(input,1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
    [fig] = show_activity_plots(activity_mean);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/' name 'mean_gaze' num2str(struct.gaze_params.gaze_idx) '_' image_props.image_name_noext '.png']);
    close all;
    fig = figure; plot(activity_mean_mean);
    fig_image = frame2im(getframe(fig));
    imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/' name 'meanmean_gaze' num2str(struct.gaze_params.gaze_idx) '_' image_props.image_name_noext '.png']);
    close all;
    [fig] = show_activity_plots(activity_max);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/' name 'max_gaze' num2str(struct.gaze_params.gaze_idx) '_' image_props.image_name_noext '.png']);
    close all;
    fig = figure;  plot(activity_max_max);
    fig_image = frame2im(getframe(fig));
    imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/' name 'maxmax_gaze' num2str(struct.gaze_params.gaze_idx) '_' image_props.image_name_noext '.png']);
    close all;
    [fig] = show_activity_plots(activity_sum);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/' name 'sum_gaze' num2str(struct.gaze_params.gaze_idx) '_' image_props.image_name_noext '.png']);
    close all;
    fig = figure;  plot(activity_sum_sum);
    fig_image = frame2im(getframe(fig));
    imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/' name 'sumsum_gaze' num2str(struct.gaze_params.gaze_idx) '_' image_props.image_name_noext '.png']);
    close all;
    fig = figure;  plot(activity_single);
    fig_image = frame2im(getframe(fig));
    imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/' name 'single_gaze' num2str(struct.gaze_params.gaze_idx) '_' image_props.image_name_noext '.png']);
    close all;

end

