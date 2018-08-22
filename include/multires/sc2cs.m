function [ RF_c_s ] = sc2cs( RF_s_c, n_channels, n_scales )



%RF_c_s = cell(n_channels,1);

for c=1:n_channels  
    %RF_c_s{c}=cell(n_scales-1,1);
    for s=1:length(RF_s_c)
           RF_c_s{c}{s}(:,:) = RF_s_c{s}(:,:,c);
    end
end



end

