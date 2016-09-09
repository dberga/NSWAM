




function [] = writefig_tgivenparams_channel(figures_in,matrix_name,channel,struct)

    
    
    output_folder = struct.file_params.outputstr_figs;
    output_prefix = struct.file_params.name;
    output_suffix = ['channel(' channel ')'];
    format = 'jpg';
    time_ini = 1;
    time_fin = struct.zli_params.n_membr;
    
    writefig_tmatrix(figures_in,matrix_name,output_folder,output_prefix,output_suffix,format,time_ini,time_fin);
    
end 


