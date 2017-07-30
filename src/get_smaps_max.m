
function [max_smap] = get_smaps_max(smaps,part)
    if ~exist('part','var') part = size(smaps,3); end
    
    smaps_part = smaps(:,:,part);
    
    if size(smaps,3) > 1
        max_smap = normalize_minmax(cummax_reduc(smaps_part));  
    else
        max_smap=smaps;
    end
end


