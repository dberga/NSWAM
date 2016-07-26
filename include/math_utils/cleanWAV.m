function [ WAV ] = cleanWAV( WAV )
    
        WAV = WAV(~cellfun('isempty',WAV));
        n_scales = numel(WAV);
        for s=1:n_scales
                n_orient = numel(WAV{s});
        end     
                

end

