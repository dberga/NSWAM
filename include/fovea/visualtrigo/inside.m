
function [yn] = inside(coord,size)
	yn = coord>=1 & coord<=size;
end