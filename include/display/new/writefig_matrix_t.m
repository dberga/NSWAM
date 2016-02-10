function [] = writefig_matrix_t(figure_in,matrix_name,output_folder,output_prefix,output_suffix,format,time)
    output_suffix = strcat(output_suffix,['_t(' int2str(time) ')']);
    writefig_matrix(figure_in,matrix_name,output_folder,output_prefix,output_suffix,format);
end