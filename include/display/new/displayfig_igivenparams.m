function [figures_out] = displayfig_igivenparams(matrix_in,struct)
        time_ini = 1;
        time_fin = struct.zli.n_membr;
      
        
        figures_out = displayfig_i(matrix_in, time_ini, time_fin);


end


