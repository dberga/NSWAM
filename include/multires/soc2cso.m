function [ RF_c_s_o ] = soc2cso( RF_s_o_c, n_channels, n_scales, n_orient )



%RF_c_s_o =cell(n_channels,1);
for c=1:n_channels    
    %RF_c_s_o{c}=cell(n_scales-1,1);
    for s=1:n_scales-1
        %RF_c_s_o{c}{s}=cell(n_orient,1);
        for o=1:n_orient
           RF_c_s_o{c}{s}{o}(:,:) = RF_s_o_c{s}{o}(:,:,c);
        end
    end
    %RF_c_s_o{c}{n_scales}{1}(:,:) = RF_s_o_c{n_scales}{1}(:,:,c);
end


end

