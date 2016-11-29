
function [map_out] = normalize_minmaxp(map_in,min_in, max_in)


if nargin < 2
max_in = max(map_in(:));
min_in = min(map_in(:));
end

map_out    = (map_in - min_in)/(max_in - min_in);

map_out(find(map_out<0))=0;


end
