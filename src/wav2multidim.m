function [ multidim ] = wav2multidim( RF_c_s_o )

    for c=1:length(RF_c_s_o)
        for s=1:length(RF_c_s_o{c})
            for o=1:size(RF_c_s_o{c}{s},3)
                multidim(:,:,s,o,c)=RF_c_s_o{c}{s}(:,:,o);
            end
        end
    end
end

