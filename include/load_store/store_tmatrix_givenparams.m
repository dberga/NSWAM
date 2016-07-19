
function [] = store_tmatrix_givenparams(tmatrix_in,matrix_name,struct)
    if struct.display_plot.store == 1
    output_folder = struct.compute.outputstr_mats;
    output_prefix = struct.image.name;
    format = 'mat';
        time_ini = 1;
        time_fin = struct.zli.n_membr;
        for time=time_ini:time_fin
            output_suffix = ['t(' int2str(time) ')'];
            store_matrix(tmatrix_in,matrix_name,output_folder,output_prefix,output_suffix, format);
        end
    end
end


