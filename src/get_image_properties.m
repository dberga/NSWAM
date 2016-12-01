function [image_props] = get_image_properties(input_image,image_name,folder_props,conf_struct)
    %get image properties
    image_props.input_image = input_image;
    image_props.image_name = image_name;
    image_props.image_name_noext = remove_extension(image_props.image_name);
    image_props.output_image_path= [folder_props.output_path '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_scanpath_path= [ folder_props.output_folder_scanpath '/' image_props.image_name_noext '.mat' ];
    
    image_props.output_image_paths = cell(1,conf_struct.gaze_params.ngazes);
    for k=1:conf_struct.gaze_params.ngazes
        image_props.output_image_paths{k} = [folder_props.output_path '/' image_props.image_name_noext '_gaze' num2str(k) '.' folder_props.output_extension];
        
    end
    
    image_props.output_mean_path = [folder_props.output_folder_mean '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_mean_path_first2 = [folder_props.output_folder_mean_first2 '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_mean_path_first2_nobaseline = [folder_props.output_folder_mean_first2_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_mean_path_nobaseline = [folder_props.output_folder_mean_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    
    
    image_props.output_gaussian_path = [folder_props.output_folder_gaussian '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_gaussian_path_first2 = [folder_props.output_folder_gaussian_first2 '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_gaussian_path_first2_nobaseline = [folder_props.output_folder_gaussian_first2_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_gaussian_path_nobaseline = [folder_props.output_folder_gaussian_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    
    image_props.output_bmap_path = [folder_props.output_folder_bmap '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_bmap_path_first2 = [folder_props.output_folder_bmap_first2 '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_bmap_path_first2_nobaseline = [folder_props.output_folder_bmap_first2_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_bmap_path_nobaseline = [folder_props.output_folder_bmap_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    

end

