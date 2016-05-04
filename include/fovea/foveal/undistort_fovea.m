function [ output_image ] = undistort_fovea( oM,oN, input_image, ifix, jfix, vAngle, lambda,e0 )

    [pM,pN,C] = size(input_image);
    input_image = double(input_image);
    output_image = zeros(pM,pN,C);
    
    %DEFAULT PARAMETERS (IF NOT SET)
    if nargin < 7

       vAngle = 10;
       lambda = 12;
       e0= 1;
       
       if nargin < 4
           ifix = round(pM/2); %center
           jfix = round(pN/2); %center
       end
    end
    
    
    
    %CALCULATE PADDING (RECTANGULAR IMAGES)
    %[x_margin, y_margin] = padding_get_margins(oM,oN);
    
    %RELOCATE FIXATION AFTER PADDING
    %ifix =  ifix+y_margin;
    %jfix = jfix+x_margin;
    
    
    %GET CORRESPONDENCE COORDINATES OF IMAGE (M,N) matrix
    [A,B] = meshgrid(1:pM,1:pN);
    
    coords = [A(:) B(:)];
    
    coords_retinal_rows = A;
    coords_retinal_cols = B;

    %coords_retinal_rows = reshape(coords_retinal_rows,pM,pN);
    %coords_retinal_cols = reshape(coords_retinal_cols,pM,pN);
    
    %RETINAL COORDINATES TO RETINAL ANGLES
    [azimuth_retinal, eccentricity_retinal] =rPixel2rAngle(coords_retinal_rows,coords_retinal_cols,ifix,jfix,pM,pN,vAngle);
    
    %RETINAL ANGLES TO VISUAL ANGLES
    [azimuth_visual,eccentricity_visual] = rAngle2vAngle(azimuth_retinal,eccentricity_retinal, lambda, e0);
    
    %VISUAL ANGLES TO VISUAL PIXELS
    [coords_image_rows, coords_image_cols] = vAngle2vPixel(azimuth_visual,eccentricity_visual,ifix, jfix, pM, pN, vAngle);
        
    %ROUND PIXEL COORDINATES, DOUBLES TO INTEGERS
    coords_image_rows = round(coords_image_rows);
    coords_image_cols = round(coords_image_cols);
    
    %FROM PIXEL COORDINATES OF RETINA TO VISUAL, OR REVERSE, OR SAME
     %output_image = recoord2(input_image,output_image, coords_retinal_rows,coords_retinal_cols, coords_image_rows, coords_image_cols);
    output_image = recoord2(input_image,output_image, coords_image_rows,coords_image_cols, coords_retinal_rows, coords_retinal_cols);
    %output_image = recoord2(input_image,output_image, coords_retinal_rows,coords_retinal_cols, coords_retinal_rows,coords_retinal_cols);
    
    %ERASE PADDING AFTER UNDISTORTION 
    %output_image = clean_distort_frames(output_image,coords_retinal_rows,coords_retinal_cols);
    %output_image = padding_square2original(output_image,x_margin,y_margin);
    
    %TO DOUBLES
    %output_image = output_image/255;

end

