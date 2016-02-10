
function [s_map] = channelcombine(channels)

[m n p] = size(channels);
s_map = sqrt(sum(channels.^2,3))*(m*n);

end

