
function [tempMean] = get_temporalMean(matrix_in,tinit,tfinal,s,o) 
    

    framesum = zeros(size(matrix_in{tinit}{s}{o}(:,:)));
    nframes = length(tinit:tfinal);
    
    for ff=tinit:tfinal
        framesum(:,:) = framesum(:,:) + matrix_in{ff}{s}{o}(:,:);    
    end
    tempMean(:,:) = framesum(:,:) ./ nframes;
    
end

    
