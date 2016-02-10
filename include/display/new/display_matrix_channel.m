
function [] = display_matrix_channel(matrix_in,matrix_name,channel,struct)
    [figures_out] = displayfig_givenparams(matrix_in,struct);
     writefig_givenparams_channel(figures_out,matrix_name,channel,struct);
end

