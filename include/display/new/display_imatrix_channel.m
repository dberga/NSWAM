function [] = display_imatrix_channel(matrix_in,matrix_name,channel,struct)
    [figures_out] = displayfig_igivenparams(matrix_in,struct);
     writefig_givenparams_channel(figures_out,matrix_name,channel,struct);
end
