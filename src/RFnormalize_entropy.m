function [ iFactor_normalized ] = RFnormalize_entropy( iFactor )
    iFactor_normalized=iFactor;
    for tmem=1:length(iFactor)
        for titer=1:length(iFactor{tmem})
            for s=1:length(iFactor{tmem}{titer})
                for o=1:length(iFactor{tmem}{titer}{s})
                    iFactor_normalized{tmem}{titer}{s}{o}(:,:)=normalize_energy(iFactor{tmem}{titer}{s}{o}(:,:));
                end
            end
        end
    end

end

