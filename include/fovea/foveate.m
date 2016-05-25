

 
function [im_out] = foveate(im_in, flag, struct )

    im_in = double(im_in);
    [M,N,~] = size(im_in);
    
    if nargin < 3
        fov_type = 'cortical';
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
    
    
    cM = oM*4;
    cN = oN*4;
            
    switch flag
        case 0 %distort
            switch fov_type 
            case 'gaussian'
                im_out = distort_gaussian(im_in);
            case 'fisheye'
                im_out = distort_fisheye(im_in); 
            case 'cortical'
                [im_in,fixationY,fixationX] = pad_image(im_in,fixationY,fixationX);
                im_out = distort_cortex(im_in,fixationY,fixationX); 
            case 'cortical_xavi'
                [im_in,fixationY,fixationX] = pad_image(im_in,fixationY,fixationX);
                im_out = mapImage2Cortex(im_in,pi,cM,cN,fixationX,fixationY);
            otherwise
               [im_in,fixationY,fixationX] = pad_image(im_in,fixationY,fixationX);
               im_out = distort_cortex(im_in,fixationY,fixationX); 
            end
        case 1 %undistort
            switch fov_type
                case 'cortical'
                        
                    im_out = undistort_cortex(im_in,fixationY,fixationX); 
                    [im_out,~,~] = unpad_image(im_out,fixationY,fixationX,oM,oN);
                case 'cortical_xavi'
                    im_out = mapCortex2Image(im_in,pi,M,N,fixationX,fixationY);
                    [im_out,~,~] = unpad_image(im_out,fixationY,fixationX,oM,oN);
                otherwise
                    im_out = undistort_cortex(im_in,fixationY,fixationX); 
                    [im_out,~,~] = unpad_image(im_out,fixationY,fixationX,oM,oN);
            end
        otherwise
            %do nothing
            
    end
    
    
    
    
    
    
    
    

end
