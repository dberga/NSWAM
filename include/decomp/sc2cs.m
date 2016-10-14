function [ RF_c_s ] = sc2cs( RF_s_c, n_channels, n_scales )



RF_c_s = cell(n_channels,n_scales,1);

for c=1:n_channels    
    for s=1:n_scales-1
           RF_c_s{c}{s}(:,:) = RF_s_c{s}(:,:,c);
    end
end



end

