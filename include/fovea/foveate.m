

 
function [im_out] = foveate(im_in, flag, struct )

    im_in = double(im_in);
    
    if nargin < 3
        fov_type = 'zli_foveal_distortion';
        [oM,oN,~] = size(im_in);
        fixationY = round(oM/2);
        fixationX = round(oN/2);
        
        if nargin < 2
            flag = 0; 
        end

    else

    fov_type = struct.image.fov_type;
    fixationY = struct.image.fixationY;
    fixationX = struct.image.fixationX;
    oM = struct.image.M;
    oN = struct.image.N;
    end
    
    if oM == 0 || oN == 0
        oM = size(im_in,1);
        oN = size(im_in,2);
    end
       
    if fixationX == 0 || fixationY == 0
        fixationY = round(oM/2);
        fixationX = round(oN/2);
    end
    
    
    
            
    switch flag
        case 0 %distort
            switch fov_type 
            case 'gaussian'
                im_out = distort_gaussian(im_in);
            case 'fisheye'
                im_out = distort_fisheye(im_in); 
            case 'zli_foveal_distortion'
                    [im_in,fixationY,fixationX] = pad_image(im_in,fixationY,fixationX);
                im_out = distort_fovea(im_in,fixationY,fixationX); 
            otherwise
                    [im_in,fixationY,fixationX] = pad_image(im_in,fixationY,fixationX);
               im_out = distort_fovea(im_in,fixationY,fixationX); 
            end
        case 1 %undistort
            switch fov_type
                case 'zli_foveal_distortion'
                        [im_in,fixationY,fixationX] = unpad_image(im_in,fixationY,fixationX,oM,oN);
                    im_out = undistort_fovea(im_in,fixationY,fixationX); 
                otherwise
                     [im_in,fixationY,fixationX] = unpad_image(im_in,fixationY,fixationX,oM,oN);
                   im_out = undistort_fovea(im_in,fixationY,fixationX); 
            end
        otherwise
            %do nothing
            
    end
    
    
    
    
    
    
    
    

end
