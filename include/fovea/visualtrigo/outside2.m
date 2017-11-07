
function [yn] = outside2(coord,min,max)
	yn = coord>max | coord<min;
end