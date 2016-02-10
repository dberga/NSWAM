
function [map_out] = normalize_map(map_in,factor, floor_flag)

if nargin < 2
	factor = 255;
	floor_flag = 1;
end

max_in = max(map_in(:));
min_in = min(map_in(:));


map_out    = factor*(map_in - min_in)/(max_in - min_in);

if floor_flag > 0
	map_out = floor(map_out);
end


end
