function [ output_image ] = distort_fovea( input_image , ifix, jfix, vAngle , lambda, e0)

    [oM,oN,C] = size(input_image); 
    input_image = double(input_image);
    
    %default parameters if not set
    if nargin < 5

       vAngle = 100;
       lambda = 12;
       e0 = 1;
       
       if nargin < 2
           ifix = round(oM/2); %center
           jfix = round(oN/2); %center
       end

    end
    
    %CALCULATE PADDING (RECTANGULAR IMAGES)
    [x_margin, y_margin] = padding_get_margins(oM,oN);
    
    %RELOCATE FIXATION AFTER PADDING
    ifix =  ifix+y_margin;
    jfix = jfix+x_margin;
    
    %ADD PADDING (-inf)
    input_image_padded = padding_rectangle2square(input_image,x_margin,y_margin,-inf);
    
    %CHANGE -inf PADDING TO MEAN
    input_image_paddedmean =  padding_zeros2mean(input_image_padded,input_image, -inf);
    
    %RECALCULATE NEW ROWS AND COLS, NOW WE HAVE PADDED IMAGE
    [pM,pN,C] = size(input_image_paddedmean);
    output_image = zeros(pM,pN,C);

    %GET CORRESPONDENCE COORDINATES OF IMAGE (pM,pN) matrix
    [coords_image_cols,coords_image_rows] = meshgrid(1:pN,1:pM);
    
    
    %VISUAL COORDINATES TO VISUAL ANGLES
    [azimuth_visual, eccentricity_visual] =vPixel2vAngle(coords_image_rows,coords_image_cols,ifix,jfix,pM,pN,vAngle);
    
    %VISUAL ANGLES TO RETINAL ANGLES
    [azimuth_retinal,eccentricity_retinal] = vAngle2rAngle(azimuth_visual,eccentricity_visual, lambda, e0);
    
    %RETINAL ANGLES TO RETINAL PIXELS
    [coords_retinal_rows, coords_retinal_cols] = rAngle2rPixel(azimuth_retinal,eccentricity_retinal,ifix, jfix, pM, pN, vAngle);

    %ERASE COORDINATES THAT ARE OUT OF THE LIMITS (1 to M, 1 to N)  
    %[coords_retinal_rows,coords_retinal_cols,coords_image_rows,coords_image_cols] = limit_coords_both2(coords_retinal_rows,coords_retinal_cols,coords_image_rows,coords_image_cols,1,1,rM,rN);
        %%[coords_retinal_rows,coords_retinal_cols] = limit_coords(coords_retinal_rows,coords_retinal_cols,1,1,rM,rN);
    
    
    %ROUND PIXEL COORDINATES, DOUBLES TO INTEGERS
    coords_retinal_rows = round(coords_retinal_rows);
    coords_retinal_cols = round(coords_retinal_cols);
    
    
    
    %FROM PIXEL COORDINATES OF RETINA TO VISUAL, OR REVERSE, OR SAME
    output_image = recoord2(input_image_paddedmean,output_image,coords_retinal_rows, coords_retinal_cols);
    %output_image = recoord2(input_image_paddedmean,output_image, coords_retinal_rows,coords_retinal_cols, coords_image_rows, coords_image_cols);
    %%output_image = recoord2(input_image_paddedmean,output_image, coords_image_rows,coords_image_cols, coords_image_rows,coords_image_cols);
    
    
    
    %CHANGE ZEROS PADDING TO MEAN
    output_image =  padding_zeros2mean(output_image,input_image);
    
    
    
    %TO DOUBLES
    %output_image = output_image/255;
    

    
end

