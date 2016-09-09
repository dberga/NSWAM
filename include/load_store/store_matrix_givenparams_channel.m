
function [] = store_matrix_givenparams_channel(matrix_in,matrix_name,channel,struct)

    
    
    output_folder = struct.file_params.outputstr_mats;
    output_prefix = struct.file_params.name;
    output_suffix = ['_channel(' channel ')'];
    format = 'mat';
    if struct.display_params.store == 1
        store_matrix(matrix_in,matrix_name,output_folder,output_prefix,output_suffix, format);
    end
end


