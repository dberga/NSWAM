
function [s_map] = channelwta2(channels)

[m n p] = size(channels);
s_map = zeros(m,n);

energies = zeros(1,p);

for o=1:p
	energies(o) = sum(sum(channels(:,:,o)));
end

[points, winner_channel] = max(energies);

s_map = channels(:,:,winner_channel);


end

