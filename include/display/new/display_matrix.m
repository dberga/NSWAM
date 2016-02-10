

function [] = display_matrix(matrix_in,matrix_name,struct)
    [figures_out] = displayfig_givenparams(matrix_in,struct);
     writefig_givenparams(figures_out,matrix_name,struct);
end
