function [ scanpath ] = get_ordered_scanpath( smap, nscans )
    %get ordered maximums from smap
    
    scanpath = zeros(nscans,2);
    
    lastmax = inf;
    for k=1:nscans
        [lastmax, maxidx] = max_second(smap(:),lastmax);
        [scanpath(k,2), scanpath(k,1)] = ind2sub(size(smap),maxidx); %x,y
    end

end

