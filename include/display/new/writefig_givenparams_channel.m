
function [] = writefig_givenparams_channel(figures_in,matrix_name,channel,struct)

    
    
    output_folder = struct.file_params.outputstr_figs;
    output_prefix = struct.file_params.name;
    output_suffix = ['channel(' channel ')'];
    format = 'jpg';
    
    writefig_matrix(figures_in,matrix_name,output_folder,output_prefix,output_suffix,format);
    
end


