function [strct]=load_default_parameters_NCZLd(mat_path)


strct = load(mat_path);
strct = strct.matrix_in;


[conf_struct_path_folder,conf_struct_path_name,conf_struct_path_ext] = fileparts(mat_path);
output_subfolder = conf_struct_path_name ;
output_folder = 'output';
output_folder_figs = 'figs'; %output_folder_figs = 'output_figs';
output_folder_mats = 'mats'; %output_folder_mats = 'output_mats';
output_folder_imgs = [output_folder '/' output_subfolder '/']; %output_folder_imgs = 'output_imgs';

strct.file_params.outputstr = [output_folder '/' output_subfolder '/'];
strct.file_params.outputstr_figs = output_folder_figs;
strct.file_params.outputstr_mats = output_folder_mats;
strct.file_params.outputstr_imgs = output_folder_imgs;

end

%fer amb csv