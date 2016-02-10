
function [figures_out] = displayfig_t_s_o(matrix_in, time_ini, time_fin, scale_ini, scale_fin, orientation_ini, orientation_fin)
    %figures_out = gobjects(length(time_ini:time_fin));
    figures_out = zeros(length(time_ini:time_fin));
    for time=time_ini:time_fin
        figures_out(time) = displayfig_s_o(matrix_in{time}, scale_ini, scale_fin, orientation_ini, orientation_fin);
    end
end



