function [  ] = fig2png( fig_path , out_path)
    if nargin < 2, out_path=[fig_path '.png']; end
    
    close all;
    figs = openfig(fig_path);
    pause(2);
    for K = 1 : length(figs)
       filename = out_path;
       saveas(figs(K), filename);
    end

end

