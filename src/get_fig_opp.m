function [ ] = get_fig_opp( input, name, folder_props,image_props, struct )

     mosaic = zeros(size(input,1),size(input,2),1,size(input,3)); mosaic(:,:,1,:) = input(:,:,:);
     figure; [fig] = montage(mosaic, 'Size',[1 3]);
     fig_image = getimage(fig);
     imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/' name '_gaze' num2str(struct.gaze_params.gaze_idx+1) '_' image_props.image_name_noext '.png']);
    close all;
end

