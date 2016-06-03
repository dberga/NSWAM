
function [tempMean] = get_temporaliterMean(matrix_in,tinit,tfinal,iinit,ifinal,s,o,c) 
    

    framesum = zeros(size(matrix_in{tinit}{iinit}{s}{o}(:,:,c)));
    nframes = length(tinit:tfinal);
    niter = length(iinit:ifinal);
    
    for ff=tinit:tfinal
        for it=iinit:ifinal
            framesum(:,:) = framesum(:,:) + matrix_in{ff}{it}{s}{o}(:,:,c);    
        end
    end
    tempMean(:,:) = framesum(:,:) ./ (nframes * niter);
    
end

    
