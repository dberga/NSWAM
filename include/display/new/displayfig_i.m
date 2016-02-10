function [figure_out] = displayfig_i(matrix_in,time_ini, time_fin)
    figure_out = figure('visible','off');
    count = 0;
        
    for time=time_ini:time_fin
            count = count +1;
            subplot(1,length(time_ini:time_fin),count), subimage(matrix_in(:,:,time));
            xlabel(['t=' int2str(time)]);
    end
end


