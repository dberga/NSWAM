function [yn] = outside(coord,size)
	yn = coord>size | coord<[1 1];
end