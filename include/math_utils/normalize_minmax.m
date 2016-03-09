
function [map_out] = normalize_minmax(map_in)



max_in = max(map_in(:));
min_in = min(map_in(:));


map_out    = (map_in - min_in)/(max_in - min_in);




end
