

 
function [im_out] = foveate(im_in, struct)

    if nargin < 2
        struct.compute.fov_type = 'zli_magnification';
    end
    
    switch struct.compute.fov_type 
        case 'gaussian'
            im_out = distort_gaussian(im_in);
        case 'fisheye'
            im_out = distort_fisheye(im_in); 
        case 'zli_magnification'
            im_out = distort_magnification(im_in); 
	case 'zli_magnification_inv'
            im_out = distort_magnification_inv(im_in); 
        otherwise
           im_out = distort_fisheye(im_in); 
    end
    
    
    

end
