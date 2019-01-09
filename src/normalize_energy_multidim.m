function [ multidim ] = normalize_energy_multidim( multidim )

    for s=1:size(multidim,3)
        for o=1:size(multidim,4)
            for c=1:size(multidim,5)
                multidim(:,:,s,o,c)=normalize_energy(multidim(:,:,s,o,c));
            end
        end
    end
end

