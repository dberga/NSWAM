
function [] = store_matrix(matrix_in,matrix_name,output_folder,output_prefix,output_suffix, format)
    filename = [output_folder '/' output_prefix '_' matrix_name '' output_suffix '.' format];
    save(filename,'matrix_in','-v7.3');
end
