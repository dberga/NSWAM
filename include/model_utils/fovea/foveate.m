

 
function [im_out] = foveate(im_in, gaussian)

if nargin < 2
	gaussian = get_gaussian(size(im_in,1),size(im_in,2),sqrt(size(im_in,1)*size(im_in,2)), 1);
end

	im_out = im_in+gaussian;

end
