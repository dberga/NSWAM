

function [figure_out] = displayfig_givenparams(matrix_in,struct)
        scale_ini = struct.wave_params.ini_scale;
        scale_fin = struct.wave_params.fin_scale;
        orientation_ini = 1;
        orientation_fin = struct.wave_params.n_orient;
        
        
        figure_out = displayfig_s_o(matrix_in, scale_ini, scale_fin, orientation_ini, orientation_fin);


end




