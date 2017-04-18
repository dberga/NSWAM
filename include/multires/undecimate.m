function [ w_undecimated ] = undecimate( w,M,N )
    
    for s=1:numel(w)
        for o=1:size(w{s},3)
            w_undecimated{s,1}(:,:,o)=imresize(w{s}(:,:,o),[M N]);
        end
    end
end

