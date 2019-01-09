function [ out_map ] = normalize_spec( in_map, smin, smax)
    
    mmin = min(in_map(:));
    mmax = max(in_map(:));
    
    %MOVE MATRIX, NEGATIVES TO POSITIVES
    if mmin < 0
        in_map = in_map + abs(mmin);
    end
    mmin = min(in_map(:));
    mmax = max(in_map(:));
    
    %MAP VALUES TO 0...1
    in_map = in_map./mmax;
    
    %MAP VALUES TO 0...MAX
    in_map = in_map .* (smax-smin);
    
    
    %MOVE MIN TO DESIRED MIN
    mmin = min(in_map(:));
    if mmin < smin
        in_map = in_map + (abs(smin) - abs(mmin));
    else
        in_map = in_map - (abs(smin) - abs(mmin));
    end
    
    out_map = in_map;

end

