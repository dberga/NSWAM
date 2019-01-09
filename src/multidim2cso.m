function [ RF_c_s_o ] = multidim2cso( multidim )

    for s=1:size(multidim,3)
        for o=1:size(multidim,4)
            for p=1:size(multidim,5)
                for c=1:size(multidim,6)
                    RF_c_s_o{c}{s}{o}(:,:)=abs(multidim(:,:,s,o,1,c))+abs(multidim(:,:,s,o,2,c));
                end
            end
        end
    end
end

