
function [s_map] = channelmax(channels)

[m n p] = size(channels);
s_map = zeros(m,n);

for r=1:m
	for c=1:n
		s_map(r,c) = max(channels(r,c,:));
	end
end


end

