
function [] = store_matrix_givenparams(matrix_in,matrix_name,struct)
    output_folder = struct.compute.outputstr_mats;
    output_prefix = struct.image.single;
    output_suffix = ''; 
    format = 'mat';
    
    store_matrix(matrix_in,matrix_name,output_folder,output_prefix,output_suffix, format);
end
