function [ output_image ] = undistort_fovea( input_image, ifix, jfix, vAngle, gamma,e0 )

    %AGREGAR MARCOS SI SE QUITARON EN DISTORT
    %[margin_up,margin_down,margin_left,margin_right] = calc_padding_margins(input_image,ifix,jfix,vAngle,gamma);
    %input_image= add_foveal_padding( input_image, margin_up, margin_down, margin_left, margin_right);
    
    [rM,rN,C] = size(input_image);
    M = rM;
    N = rN;  
    output_image = zeros(M,N,3);

    
    
    %DEFAULT PARAMETERS (IF NOT SET)
    if nargin < 5

       vAngle = 30;
       gamma = 10;
       e0= 1;
       
       if nargin < 2
           ifix = round(N/2); %center
           jfix = round(M/2); %center
       end
    end
    
    
    %GET CORRESPONDENCE COORDINATES OF IMAGE (M,N) matrix
    [A,B] = meshgrid(1:rM,1:rN);
    
    coords = [A(:) B(:)];
    
    coords_retinal_rows = coords(1:end,1);
    coords_retinal_cols = coords(1:end,2);

    coords_retinal_rows = reshape(coords_retinal_rows,rM,rN);
    coords_retinal_cols = reshape(coords_retinal_cols,rM,rN);
    
    %RETINAL COORDINATES TO RETINAL ANGLES
    [azimuth_retinal, eccentricity_retinal] =rPixel2rAngle(coords_retinal_rows,coords_retinal_cols,ifix,jfix,rM,rN,vAngle);
    
    %RETINAL ANGLES TO VISUAL ANGLES
    [azimuth_visual,eccentricity_visual] = rAngle2vAngle(azimuth_retinal,eccentricity_retinal, gamma, e0);
    
    %VISUAL ANGLES TO VISUAL PIXELS
    [coords_image_rows, coords_image_cols] = vAngle2vPixel(azimuth_visual,eccentricity_visual,ifix, jfix, rM, rN, vAngle);

    %ERASE COORDINATES THAT ARE OUT OF THE LIMITS (1 to M, 1 to N)    
    %[coords_image_rows,coords_image_cols,coords_retinal_rows,coords_retinal_cols] = limit_coords_both2(coords_image_rows,coords_image_cols,coords_retinal_rows,coords_retinal_cols,1,1,rM,rN);
        %%[coords_image_rows,coords_image_cols] = limit_coords(coords_image_rows,coords_image_cols,1,1,M,N);
        
    %ROUND PIXEL COORDINATES, DOUBLES TO INTEGERS
    coords_image_rows = round(coords_image_rows);
    coords_image_cols = round(coords_image_cols);
    
    %FROM PIXEL COORDINATES OF RETINA TO VISUAL, OR REVERSE, OR SAME
    %output_image = recoord2(input_image,output_image, coords_retinal_rows,coords_retinal_cols, coords_image_rows, coords_image_cols);
    %output_image = recoord2(input_image,output_image, coords_retinal_rows,coords_retinal_cols, coords_retinal_rows,coords_retinal_cols);
    output_image = recoord2(input_image,output_image, coords_image_rows,coords_image_cols, coords_retinal_rows, coords_retinal_cols);
    
    %REMOVER MARCOS SI EXISTEN
    %output_image = clean_distort_frames(output_image,coords_retinal_rows,coords_retinal_cols);
    
    
    %TO DOUBLES
    output_image = output_image/255;

end

