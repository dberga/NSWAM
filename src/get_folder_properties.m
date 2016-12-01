function [folder_props] = get_folder_properties(output_folder,conf_struct_path_name,output_folder_mats,output_extension)
    %get folder properties
    folder_props.output_folder = output_folder ;
    folder_props.output_subfolder = conf_struct_path_name ;
    
    folder_props.output_path = [folder_props.output_folder '/' folder_props.output_subfolder];
    folder_props.output_folder_mats = output_folder_mats ;
    folder_props.output_extension = output_extension ;
    folder_props.output_folder_scanpath = [ folder_props.output_path '/' 'scanpath'];
    folder_props.output_folder_figs = [ folder_props.output_path '/' 'figs'];
    
    folder_props.output_folder_mean = [ folder_props.output_folder_scanpath '/' 'mean' '_' folder_props.output_subfolder];
    folder_props.output_folder_mean_first2 = [ folder_props.output_folder_scanpath '/' 'mean_first2' '_' folder_props.output_subfolder];
    folder_props.output_folder_mean_first2_nobaseline = [ folder_props.output_folder_scanpath '/' 'mean_first2_nobaseline' '_' folder_props.output_subfolder];
    folder_props.output_folder_mean_nobaseline = [ folder_props.output_folder_scanpath '/' 'mean_nobaseline' '_' folder_props.output_subfolder];
    folder_props.output_folder_gaussian = [ folder_props.output_folder_scanpath '/' 'gaussian' '_' folder_props.output_subfolder];
    folder_props.output_folder_gaussian_first2 = [ folder_props.output_folder_scanpath '/' 'gaussian_first2' '_' folder_props.output_subfolder];
    folder_props.output_folder_gaussian_first2_nobaseline = [ folder_props.output_folder_scanpath '/' 'gaussian_first2_nobaseline' '_' folder_props.output_subfolder];
    folder_props.output_folder_gaussian_nobaseline = [ folder_props.output_folder_scanpath '/' 'gaussian_nobaseline' '_' folder_props.output_subfolder];
    folder_props.output_folder_bmap = [ folder_props.output_folder_scanpath '/' 'bmap' '_' folder_props.output_subfolder];
    folder_props.output_folder_bmap_first2 = [ folder_props.output_folder_scanpath '/' 'bmap_first2' '_' folder_props.output_subfolder];
    folder_props.output_folder_bmap_first2_nobaseline = [ folder_props.output_folder_scanpath '/' 'bmap_first2_nobaseline' '_' folder_props.output_subfolder];
    folder_props.output_folder_bmap_nobaseline = [ folder_props.output_folder_scanpath '/' 'bmap_nobaseline' '_' folder_props.output_subfolder];
    
    if ~exist(folder_props.output_folder,'dir') mkdir(folder_props.output_folder); end
    if ~exist(folder_props.output_path,'dir') mkdir(folder_props.output_path); end
    if ~exist(folder_props.output_folder_mats,'dir') mkdir(folder_props.output_folder_mats); end
    if ~exist(folder_props.output_folder_scanpath,'dir') mkdir(folder_props.output_folder_scanpath); end
    if ~exist(folder_props.output_folder_figs,'dir') mkdir(folder_props.output_folder_figs); end
    
    if ~exist(folder_props.output_folder_mean,'dir') mkdir(folder_props.output_folder_mean); end
    if ~exist(folder_props.output_folder_mean_first2,'dir') mkdir(folder_props.output_folder_mean_first2); end
    if ~exist(folder_props.output_folder_mean_first2_nobaseline,'dir') mkdir(folder_props.output_folder_mean_first2_nobaseline); end
    if ~exist(folder_props.output_folder_mean_nobaseline,'dir') mkdir(folder_props.output_folder_mean_nobaseline); end
    if ~exist(folder_props.output_folder_gaussian,'dir') mkdir(folder_props.output_folder_gaussian); end
    if ~exist(folder_props.output_folder_gaussian_first2,'dir') mkdir(folder_props.output_folder_gaussian_first2); end
    if ~exist(folder_props.output_folder_gaussian_first2_nobaseline,'dir') mkdir(folder_props.output_folder_gaussian_first2_nobaseline); end
    if ~exist(folder_props.output_folder_gaussian_nobaseline,'dir') mkdir(folder_props.output_folder_gaussian_nobaseline); end
    if ~exist(folder_props.output_folder_bmap,'dir') mkdir(folder_props.output_folder_bmap); end
    if ~exist(folder_props.output_folder_bmap_first2,'dir') mkdir(folder_props.output_folder_bmap_first2); end
    if ~exist(folder_props.output_folder_bmap_first2_nobaseline,'dir') mkdir(folder_props.output_folder_bmap_first2_nobaseline); end
    if ~exist(folder_props.output_folder_bmap_nobaseline,'dir') mkdir(folder_props.output_folder_bmap_nobaseline); end

end


