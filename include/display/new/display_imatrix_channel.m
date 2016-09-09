function [] = display_imatrix_channel(matrix_in,matrix_name,channel,struct)
    if struct.display_params.savefigs == 1
    [figures_out] = displayfig_igivenparams(matrix_in,struct);
     writefig_givenparams_channel(figures_out,matrix_name,channel,struct);
    end
end
