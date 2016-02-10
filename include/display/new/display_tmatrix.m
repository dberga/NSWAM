
function [] = display_tmatrix(matrix_in,matrix_name,struct)
    if struct.display_plot.savefigs == 1
    [figures_out] = displayfig_tgivenparams(matrix_in,struct);
     writefig_tgivenparams(figures_out,matrix_name,struct);
    end
end

