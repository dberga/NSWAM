function [ output_image ] = distort_fovea( input_image , ifix, jfix, vAngle , gamma)

    [M,N,C] = size(input_image);
    rM = M;
    rN = N;  
    output_image = zeros(rM,rN,3);

    %default parameters if not set
    if nargin < 5

       vAngle = 30;
       gamma = 1.5;
       
       if nargin < 2
           ifix = round(N/2); %center
           jfix = round(M/2); %center
       end

    end
    
    
    %GET CORRESPONDENCE COORDINATES OF IMAGE (M,N) matrix
    [A,B] = meshgrid(1:M,1:N);
    
    coords = [A(:) B(:)];
    
    coords_image_rows = coords(1:end,1);
    coords_image_cols = coords(1:end,2);

    coords_image_rows = reshape(coords_image_rows,M,N);
    coords_image_cols = reshape(coords_image_cols,M,N);
        
    %VISUAL COORDINATES TO VISUAL ANGLES
    [azimuth_visual, eccentricity_visual] =vPixel2vAngle(coords_image_rows,coords_image_cols,ifix,jfix,M,N,vAngle);
    
    %VISUAL ANGLES TO RETINAL ANGLES
    [azimuth_retinal,eccentricity_retinal] = vAngle2rAngle(azimuth_visual,eccentricity_visual, gamma);
    
    %RETINAL ANGLES TO RETINAL PIXELS
    [coords_retinal_rows, coords_retinal_cols] = rAngle2rPixel(azimuth_retinal,eccentricity_retinal,ifix, jfix, M, N, vAngle);

    %ERASE COORDINATES THAT ARE OUT OF THE LIMITS (1 to M, 1 to N)  
    %[coords_retinal_rows,coords_retinal_cols,coords_image_rows,coords_image_cols] = limit_coords_both2(coords_retinal_rows,coords_retinal_cols,coords_image_rows,coords_image_cols,1,1,rM,rN);
        %%[coords_retinal_rows,coords_retinal_cols] = limit_coords(coords_retinal_rows,coords_retinal_cols,1,1,rM,rN);
    
    
    %ROUND PIXEL COORDINATES, DOUBLES TO INTEGERS
    coords_retinal_rows = round(coords_retinal_rows);
    coords_retinal_cols = round(coords_retinal_cols);
    
    
    
    %FROM PIXEL COORDINATES OF RETINA TO VISUAL, OR REVERSE, OR SAME
    %%output_image = recoord2(input_image,output_image, coords_image_rows,coords_image_cols, coords_retinal_rows, coords_retinal_cols);
    output_image = recoord2(input_image,output_image, coords_retinal_rows,coords_retinal_cols, coords_image_rows, coords_image_cols);
    %%output_image = recoord2(input_image,output_image, coords_image_rows,coords_image_cols, coords_image_rows,coords_image_cols);
    
    %REMOVER MARCOS SI EXISTEN
    output_image = clean_distort_frames(output_image,coords_image_rows,coords_image_cols);
    
    
    %TO DOUBLES
    output_image = output_image/255;
    

    
end

