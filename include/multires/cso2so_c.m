function [ RF_s_o_c ] = cso2so_c( RF_c_s_o, n_channels, n_scales )
if nargin < 3, n_scales=length(RF_c_s_o{1}); end
if nargin < 2, n_channels=3; end



for c=1:length(RF_c_s_o)    
    for s=1:length(RF_c_s_o{c})
        for o=1:length(RF_c_s_o{c}{s})
           RF_s_o_c{s}{o}(:,:,c) = RF_c_s_o{c}{s}{o};
        end
    end
end



end