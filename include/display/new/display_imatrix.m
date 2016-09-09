

function [] = display_imatrix(matrix_in,matrix_name,struct)
    if struct.display_params.savefigs == 1
    [figures_out] = displayfig_igivenparams(matrix_in,struct);
     writefig_givenparams(figures_out,matrix_name,struct);
    end
end

