

 
function [im_out] = foveate(im_in, flag, struct )

    im_in = double(im_in);
    if ~exist('flag','var')
        flag = 0;
    end
    
    
    
%cortex_params
%     cm_method = magnification method
%     cortex_width = image cortex size to output (resolution)
%     a = vicinity a
%     b = vicinity b
%     lambda = scaling parameter (mm)
%     isoPolarGrad
%     eccWidth
%     mirroring = keep drawing coords outside of the visual field
%     cortex_max_elong_mm = size of cortex in mm
%     cortex_max_az_mm = size of cortex in mm
    
%gaze_params
%     orig_width = total image width (just as reference for inverse)
%     orig_height = total image width (just as reference for inverse)
%     fov_x = horizontal coordinate of fixation
%     fov_y = vertical coordinate of fixation
%     img_diag_angle = diagonal visual angle of experiment
%     

    if ~exist('struct','var')
        cortex_params.cm_method = 'schwartz_monopole';
        cortex_params.cortex_width = 128;
%         cortex_params.a=degtorad(0.77);
        cortex_params.a=1.05;
%         cortex_params.b=degtorad(150);
        cortex_params.b=150;
        cortex_params.alpha1=0.95;
        cortex_params.alpha2=0.5;
        cortex_params.alpha3=0.2;
        cortex_params.lambda=12;
        cortex_params.isoPolarGrad=0.1821;
        cortex_params.eccWidth=0.7609;
        cortex_params.cortex_max_elong_mm = 120;
        cortex_params.cortex_max_az_mm = 60;
        cortex_params.mirroring = 1;
  
        gaze_params.orig_width = size(im_in,2); %unknown on undistort
        gaze_params.orig_height = size(im_in,1); %unknown on undistort
        gaze_params.fov_x = round(gaze_params.orig_width/2);
        gaze_params.fov_y = round(gaze_params.orig_height/2);
        gaze_params.img_diag_angle = degtorad(35.12);
        gaze_params.fov_type = 'cortical';
    else
        cortex_params = struct.cortex_params;
        gaze_params = struct.gaze_params;
        if gaze_params.fov_x == 0 || gaze_params.fov_y == 0
            gaze_params.fov_x = round(gaze_params.orig_width/2);
            gaze_params.fov_y = round(gaze_params.orig_height/2);
        end
        
    end
   
    switch flag
        case 0 %distort
            switch gaze_params.fov_type 
            case 'gaussian'
                im_out = distort_gaussian(im_in);
            case 'fisheye'
                im_out = distort_fisheye(im_in); 
            case 'cortical'
                for c=1:size(im_in,3)
                    im_out(:,:,c) = mapImage2Cortex(im_in(:,:,c),cortex_params,gaze_params);
                end
            otherwise
                %nada
            end
        case 1 %undistort
            switch gaze_params.fov_type
                case 'cortical'
                    for c=1:size(im_in,3)
                        im_out(:,:,c) = mapCortex2Image(im_in(:,:,c),cortex_params,gaze_params);
                    end
                otherwise
                   %nada
            end
        case 2 %distort, then undistort
            switch gaze_params.fov_type
                case 'cortical'
                    for c=1:size(im_in,3)
                        cortex(:,:,c) = mapImage2Cortex(im_in(:,:,c),cortex_params,gaze_params);
                        im_out(:,:,c) = mapCortex2Image(cortex(:,:,c),cortex_params,gaze_params);
                    end
                otherwise
                   %nada
            end
        case 3 %undistort, then distort
            switch gaze_params.fov_type
                case 'cortical'
                    for c=1:size(im_in,3)
                        im_aux(:,:,c) = mapCortex2Image(im_in(:,:,c),cortex_params,gaze_params);
                        im_out(:,:,c) = mapImage2Cortex(im_in(:,:,c),cortex_params,gaze_params);
                        
                    end
                otherwise
                   %nada
            end
        otherwise
            %do nothing
            
    end
    %figure,imagesc(normalize_minmax(im_out))
    %figure,imagesc(normalize_minmax(cortex))
    
end




