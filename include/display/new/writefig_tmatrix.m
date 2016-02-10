

function [] = writefig_tmatrix(figures_in,matrix_name,output_folder,output_prefix,output_suffix,format,time_ini,time_fin)
    for time=time_ini:time_fin
        writefig_matrix_t(figures_in(time),matrix_name,output_folder,output_prefix,output_suffix,format,time);
    end
end



