
function [mean_smap] = get_smaps_mean(smaps,part)
    if ~exist('part','var') part = size(smaps,3); end
    
    smaps_part = smaps(:,:,part);
    
    mean_smap = normalize_minmax(mean(smaps_part,3));  
    
end


