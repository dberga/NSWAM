
function [tempMean] = get_temporalMean(matrix_in,tinit,tfinal,s,o,c) 
    

    framesum = zeros(size(matrix_in{tinit}{s}{o}(:,:,c)));
    nframes = length(tinit:tfinal);
    
    
    for ff=tinit:tfinal
        framesum(:,:) = framesum(:,:) + matrix_in{ff}{s}{o}(:,:,c);    
    end
    tempMean(:,:) = framesum(:,:) ./ nframes;
    
end

    
