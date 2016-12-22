function [image_props] = get_image_properties(input_image,image_name,folder_props,conf_struct)
    %get image properties
    image_props.input_image = input_image;
    image_props.image_name = image_name;
    image_props.image_name_noext = remove_extension(image_props.image_name);
    image_props.output_image_path= [folder_props.output_path '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_scanpath_path= [ folder_props.output_folder_scanpath '/' image_props.image_name_noext '.mat' ];
    
    image_props.output_image_paths = cell(1,conf_struct.gaze_params.ngazes);
    for k=1:conf_struct.gaze_params.ngazes
        image_props.output_image_paths{k} = [folder_props.output_folder_gazes{k} '/' image_props.image_name_noext '.' folder_props.output_extension];
    end
    
    
    for i=1:conf_struct.gaze_params.ngazes %ngazes
        image_props.output_mean_path{i} = [folder_props.output_folder_mean{i} '/' image_props.image_name_noext '.' folder_props.output_extension];
        image_props.output_mean_nobaseline_path{i} = [folder_props.output_folder_mean_nobaseline{i} '/' image_props.image_name_noext '.' folder_props.output_extension];
        image_props.output_gaussian_path{i} = [folder_props.output_folder_gaussian{i} '/' image_props.image_name_noext '.' folder_props.output_extension];
        image_props.output_gaussian_nobaseline_path{i} = [folder_props.output_folder_gaussian_nobaseline{i} '/' image_props.image_name_noext '.' folder_props.output_extension];
        image_props.output_bmap_path{i} = [folder_props.output_folder_bmap{i} '/' image_props.image_name_noext '.' folder_props.output_extension];
        image_props.output_bmap_nobaseline_path{i} = [folder_props.output_folder_bmap_nobaseline{i} '/' image_props.image_name_noext '.' folder_props.output_extension];
        
    end
    
end

