function [strct]=load_default_parameters_NCZLd(mat_path)


strct = load(mat_path);
strct = strct.matrix_in;

output_folder = 'output';
output_subfolder = remove_extension(mat_path);
output_folder_figs = 'output_figs';
output_folder_mats = 'output_mats';
output_folder_imgs = 'output_imgs';

strct.compute.outputstr = ['output' '/' output_subfolder '/'];
strct.compute.outputstr_figs = [strct.compute.outputstr output_folder_figs];
strct.compute.outputstr_mats = [strct.compute.outputstr output_folder_mats];
strct.compute.outputstr_imgs = [strct.compute.outputstr output_folder_imgs];

end

%fer amb csv