
function [sum_smap] = get_smaps_sum(smaps,part)
    if ~exist('part','var') part = size(smaps,3); end
    
    smaps_part = smaps(:,:,part);
    
    if size(smaps,3) > 1
        sum_smap = normalize_minmax(sum(smaps_part,3));  
    else
        sum_smap=smaps;
    end
end


