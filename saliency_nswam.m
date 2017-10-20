function [ smap,scanpath,smaps] = saliency_nswam( input_image, input_path )

    
    conf_struct_path = 'conf';
    output_folder = 'output';
    output_folder_mats = 'mats';
    output_extension='png';
    
    %compute saliency
    [smap,scanpath,smaps]=nswam(input_image,input_path,conf_struct_path,output_folder,output_folder_mats,output_extension);

end

