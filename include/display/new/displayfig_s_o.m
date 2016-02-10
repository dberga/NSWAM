function [figure_out] = displayfig_s_o(matrix_in, scale_ini, scale_fin, orientation_ini, orientation_fin)
    figure_out = figure('visible','off');
    count = 0;
        
    for scale=scale_ini:scale_fin
        for orientation=orientation_ini:orientation_fin
            count = count +1;
            subplot(length(scale_ini:scale_fin),length(orientation_ini:orientation_fin),count), subimage(matrix_in{scale}{orientation}(:,:));
            xlabel(['s=' int2str(scale)]);
            ylabel(['o=' int2str(orientation)]);
        end
    end
end
