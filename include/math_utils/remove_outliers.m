function [ out_map ] = remove_outliers( in_map)

    
    
    %remove inf and nan
    in_map(isinf(in_map) & in_map > 0) = max(max(in_map(isinf(in_map)==0)));
    in_map(isinf(in_map) & in_map < 0) = min(min(in_map(isinf(in_map)==0)));
    in_map(isnan(in_map)) = min(min(in_map(isinf(in_map)==0)));
        
    %remove outliers
    sorted_in_map = sort(in_map(:));
    mmin = min(min(in_map));
    mmin2=sorted_in_map(2);
    if abs(mmin) - abs(mmin2) > mean(std(in_map))
        mmin=mmin2;
        in_map(in_map < mmin) = mmin;
    end
    mmax = max(max(in_map));
    mmax2 = sorted_in_map(end-1);
    if abs(mmax) - abs(mmax2) > mean(std(in_map))
        mmax=mmax2;
        in_map(in_map > mmax) = mmax;
    end
    
    out_map = in_map;
    
end

