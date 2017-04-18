
function [sum_smap] = get_smaps_sum(smaps,part)
    if ~exist('part','var') part = size(smaps,3); end
    
    smaps_part = smaps(:,:,part);
    
    sum_smap = normalize_minmax(sum(smaps_part,3));  
    
end


