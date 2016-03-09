
function [tempMean] = get_temporalMeanc(matrix_in,tinit,tfinal,s,o,channel) 
    

    framesum = zeros(size(matrix_in{tinit}{s}{o}(:,:,channel)));
    nframes = length(tinit:tfinal);
    
    for ff=tinit:tfinal
        framesum(:,:,channel) = framesum(:,:,channel) + matrix_in{ff}{s}{o}(:,:,channel);    
    end
    tempMean(:,:,channel) = framesum(:,:,channel) ./ nframes;
    
end

    
