
function [tempMean] = get_temporalMean2(matrix_in,tinit,tfinal) 
    

    framesum = zeros(size(matrix_in(:,:,tinit)));
    nframes = length(tinit:tfinal);
    
    for ff=tinit:tfinal
        framesum(:,:) = framesum(:,:) + matrix_in(:,:,ff);    
    end
    tempMean(:,:) = framesum(:,:) ./ nframes;
    
end
