
function [s_map] = channelwta(channels)

[m n p] = size(channels);
s_map = zeros(m,n);


for o=1:p
	maximums(o) = max(max(channels(:,:,o)));
end

[points, winner_channel] = max(maximums);

s_map = channels(:,:,winner_channel);


end

