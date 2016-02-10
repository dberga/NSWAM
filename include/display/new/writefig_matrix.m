function [] = writefig_matrix(figure_in,matrix_name,output_folder,output_prefix,output_suffix,format)
    filename = [output_folder '/' output_prefix '_' matrix_name '_' output_suffix '.' format];
    saveas(figure_in,filename);
end
