function [folder_props] = get_folder_properties(output_folder,conf_struct_path_name,output_folder_mats,output_extension,conf_struct)
    %get folder properties
    folder_props.output_folder = output_folder ;
    folder_props.output_subfolder = conf_struct_path_name ;
    
    folder_props.output_path = [folder_props.output_folder '/' folder_props.output_subfolder];
    folder_props.output_folder_mats = output_folder_mats ;
    folder_props.output_extension = output_extension ;
    folder_props.output_folder_scanpath = [ folder_props.output_path '/' 'scanpath'];
    folder_props.output_folder_figs = [ folder_props.output_path '/' 'figs'];
    
    if ~exist(folder_props.output_folder,'dir') mkdir(folder_props.output_folder); end
    if ~exist(folder_props.output_path,'dir') mkdir(folder_props.output_path); end
    if ~exist(folder_props.output_folder_mats,'dir') mkdir(folder_props.output_folder_mats); end
    if ~exist(folder_props.output_folder_scanpath,'dir') mkdir(folder_props.output_folder_scanpath); end
    if ~exist(folder_props.output_folder_figs,'dir') mkdir(folder_props.output_folder_figs); end
    
    
    for i=1:conf_struct.gaze_params.ngazes %ngazes
        folder_props.output_folder_gazes{i} = [ folder_props.output_path '/' 'gazes' '/' num2str(i) ];
        folder_props.output_folder_mean{i} = [ folder_props.output_path '/' 'mean' '/' num2str(i) ];
        folder_props.output_folder_mean_nobaseline{i} = [ folder_props.output_path '/' 'mean_nobaseline' '/' num2str(i) ];
        folder_props.output_folder_gaussian{i} = [ folder_props.output_path '/' 'gaussian' '/' num2str(i)];
        folder_props.output_folder_gaussian_nobaseline{i} = [ folder_props.output_path '/' 'gaussian_nobaseline' '/' num2str(i) ];
        folder_props.output_folder_bmap{i} = [ folder_props.output_path '/' 'bmap' '/' num2str(i) ];
        folder_props.output_folder_bmap_nobaseline{i} = [ folder_props.output_path '/' 'bmap_nobaseline' '/' num2str(i) ];
        
        
        if ~exist(folder_props.output_folder_gazes{i},'dir') mkdir(folder_props.output_folder_gazes{i}); end
        if ~exist(folder_props.output_folder_mean{i},'dir') mkdir(folder_props.output_folder_mean{i}); end
        if ~exist(folder_props.output_folder_mean_nobaseline{i},'dir') mkdir(folder_props.output_folder_mean_nobaseline{i}); end
        if ~exist(folder_props.output_folder_gaussian{i},'dir') mkdir(folder_props.output_folder_gaussian{i}); end
        if ~exist(folder_props.output_folder_gaussian_nobaseline{i},'dir') mkdir(folder_props.output_folder_gaussian_nobaseline{i}); end
        if ~exist(folder_props.output_folder_bmap{i},'dir') mkdir(folder_props.output_folder_bmap{i}); end
        if ~exist(folder_props.output_folder_bmap_nobaseline{i},'dir') mkdir(folder_props.output_folder_bmap_nobaseline{i}); end
        
        
    end
    
    
    
    for i=1:conf_struct.gaze_params.ngazes %ngazes
        if ~exist(folder_props.output_folder_mean{i},'dir')  mkdir(folder_props.output_folder_mean{i}); end
        if ~exist(folder_props.output_folder_mean_nobaseline{i},'dir')  mkdir(folder_props.output_folder_mean_nobaseline{i}); end
        if ~exist(folder_props.output_folder_gaussian{i},'dir')  mkdir(folder_props.output_folder_gaussian{i}); end
        if ~exist(folder_props.output_folder_gaussian_nobaseline{i},'dir')  mkdir(folder_props.output_folder_gaussian_nobaseline{i}); end
        if ~exist(folder_props.output_folder_bmap{i},'dir')  mkdir(folder_props.output_folder_bmap{i}); end
        if ~exist(folder_props.output_folder_bmap_nobaseline{i},'dir')  mkdir(folder_props.output_folder_bmap_nobaseline{i}); end

    end
    
    

end


