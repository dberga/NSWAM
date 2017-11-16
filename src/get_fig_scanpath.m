function [ ] = get_fig_scanpath( input, name, folder_props,image_props, struct )

     %mosaic = zeros(size(input,1),size(input,2),1,size(input,3)); mosaic(:,:,1,:) = input(:,:,:);
     %figure; [fig] = montage(mosaic, 'Size',[1 3]);
     
     scanpath_path=[folder_props.output_folder_scanpath '/' image_props.image_name_noext '.mat'];
     fig = visualize_scanpath(input,scanpath_path);
     fig_image = getimage(fig);
     imwrite(im2uint8(fig_image),[folder_props.output_folder_figs '/' name '_' image_props.image_name_noext '.png']);
     close all;
end

