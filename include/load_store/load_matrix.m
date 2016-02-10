
function [matrix_out] = load_matrix(matrix_name,output_folder,output_prefix,output_suffix, format)
    filename = [output_folder '/' output_prefix '_' matrix_name '' output_suffix '.' format];
    matrix_out = matfile(filename);
end
