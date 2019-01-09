function [ RF_s_c ] = cs2sc( RF_c_s, n_channels, n_scales )
if nargin < 3, n_scales=length(RF_c_s{1});end
if nargin < 2, n_channels=3; end


%RF_s_c = cell(n_scales,n_channels,1);

for c=1:n_channels    
    for s=1:length(RF_c_s{c})
           RF_s_c{s}(:,:,c) = RF_c_s{c}{s}(:,:);
    end
end



end