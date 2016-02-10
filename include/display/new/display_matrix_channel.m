
function [] = display_matrix_channel(matrix_in,matrix_name,channel,struct)

    if struct.display_plot.savefigs == 1
        [figures_out] = displayfig_givenparams(matrix_in,struct);
        writefig_givenparams_channel(figures_out,matrix_name,channel,struct);
    end
end

