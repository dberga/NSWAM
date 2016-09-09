function [figures_out] = displayfig_tgivenparams(matrix_in,struct)
        time_ini = 1;
        time_fin = struct.zli_params.n_membr;
        scale_ini = struct.wave_params.ini_scale;
        scale_fin = struct.wave_params.fin_scale;
        orientation_ini = 1;
        orientation_fin = struct.wave_params.n_orient;
        
        
        figures_out = displayfig_t_s_o(matrix_in, time_ini, time_fin, scale_ini, scale_fin, orientation_ini, orientation_fin);


end
