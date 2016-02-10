
function [] = writefig_givenparams_channel(figures_in,matrix_name,channel,struct)

    
    
    output_folder = struct.compute.outputstr_figs;
    output_prefix = struct.image.single;
    output_suffix = ['channel(' channel ')'];
    format = 'jpg';
    
    writefig_matrix(figures_in,matrix_name,output_folder,output_prefix,output_suffix,format);
    
end


