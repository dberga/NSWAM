function [] = display_tmatrix_channel(matrix_in,matrix_name,channel,struct)
    if struct.display_plot.savefigs == 1
    [figures_out] = displayfig_tgivenparams(matrix_in,struct);
     writefig_tgivenparams_channel(figures_out,matrix_name,channel,struct);
    end
end