

 
function [im_out] = foveate(im_in, flag, struct )

    im_in = double(im_in);
    
    if nargin < 3
        fov_type = 'cortical_xavi';
        [oM,oN,~] = size(im_in);
        
        fixationY = round(oM/2);
        fixationX = round(oN/2);
        
        cN = 128;
        vAngle = 35.12;  vAngle = vAngle*(pi/180); %to radians
        lambda = 12;
        e0 = 1; e0=e0*(pi/180);  %to radians
        
        if nargin < 2
            flag = 0; 
        end

    else

    fov_type = struct.image.fov_type;
    fixationY = struct.image.fixationY;
    fixationX = struct.image.fixationX;
    oM = struct.image.M;
    oN = struct.image.N;
    
    cN = struct.image.cortex_width;
    vAngle = struct.image.vAngle; vAngle = vAngle*(pi/180); %to radians
    lambda = struct.image.lambda;
    e0 = struct.image.e0; e0=e0*(pi/180); %to radians
    
    end
    
    

    
    



    switch flag
        case 0 %distort
            switch fov_type 
            case 'gaussian'
                im_out = distort_gaussian(im_in);
            case 'fisheye'
                im_out = distort_fisheye(im_in); 
            case 'cortical'
                %[im_in,fixationY,fixationX] = pad_image(im_in,fixationY,fixationX);
                im_out = distort_cortex(im_in,fixationY,fixationX,cN,vAngle); 
            case 'cortical_xavi'
                %[im_in,fixationY,fixationX] = pad_image(im_in,fixationY,fixationX);
                for c=1:size(im_in,3)
                    im_out(:,:,c) = mapImage2Cortex(im_in(:,:,c),vAngle,cN,fixationX,fixationY,lambda,e0);
                end
            otherwise
               %[im_in,fixationY,fixationX] = pad_image(im_in,fixationY,fixationX);
               im_out = distort_cortex(im_in,fixationY,fixationX); 
            end
        case 1 %undistort
            switch fov_type
                case 'cortical'
                        
                    im_out = undistort_cortex(im_in,fixationY,fixationX,oM,oN,vAngle); 
                    %[im_out,~,~] = unpad_image(im_out,fixationY,fixationX,oM,oN);
                case 'cortical_xavi'
                    for c=1:size(im_in,3)
                        im_out(:,:,c) = mapCortex2Image(im_in(:,:,c),vAngle,oN,oM,fixationX,fixationY,lambda,e0);
                    end
                    %[im_out,~,~] = unpad_image(im_out,fixationY,fixationX,oM,oN);
                otherwise
                    %im_out = undistort_cortex(im_in,fixationY,fixationX); 
                    %[im_out,~,~] = unpad_image(im_out,fixationY,fixationX,oM,oN);
            end
        otherwise
            %do nothing
            
    end
    
    
    
end


% Distance in cm: 61.00
% Screen width resolution in px: 1024
% Screen height resolution in px: 768
% Screen width in cm: 38.61
% Screen height in cm: 28.96
% Width of screen subtends 35.12° visual angle
% 1° of horizontal visual angle: 28.24 pixels
% Height of screen subtends 26.71° visual angle
% 1° of vertical visual angle: 28.24 pixels