function [ RF_s_c ] = cs2sc( RF_c_s, n_channels, n_scales )



%RF_s_c = cell(n_scales,n_channels,1);

for c=1:n_channels    
    for s=1:length(RF_c_s{c})
           RF_s_c{s}(:,:,c) = RF_c_s{c}{s}(:,:);
    end
end



end