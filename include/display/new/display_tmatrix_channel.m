function [] = display_tmatrix_channel(matrix_in,matrix_name,channel,struct)
    [figures_out] = displayfig_tgivenparams(matrix_in,struct);
     writefig_tgivenparams_channel(figures_out,matrix_name,channel,struct);
end