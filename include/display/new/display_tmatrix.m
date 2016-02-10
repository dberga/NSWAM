
function [] = display_tmatrix(matrix_in,matrix_name,struct)
    [figures_out] = displayfig_tgivenparams(matrix_in,struct);
     writefig_tgivenparams(figures_out,matrix_name,struct);
end

