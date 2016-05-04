function [ retinal_image ] = distort_fovea_nou( image, ifix, jfix, vAngle_image, lambda,e0 )

    [M,N,C] = size(image);
    image = double(image);
    
    
    
    %DEFAULT PARAMETERS (IF NOT SET)
    if nargin < 7

       vAngle_image = 20;
       
       %max_r = sqrt(M*M+N*N);
%        lambda = sqrt(M*M+N*N)/vAngle_retina
        %vAngle_retina = 3*vAngle_image;
       %lambda = max_r/vAngle_retina;
       vAngle_retina = 30;
       lambda = 1.2;
       e0= 1;
       
       if nargin < 4
           ifix = round(M/2); %center
           jfix = round(N/2); %center
       end
    end
    
    
    %GET CORRESPONDENCE COORDINATES OF IMAGE (M,N) matrix
    [coords_retinal_cols,coords_retinal_rows] = meshgrid(1:N,1:M);
    

    %RETINAL COORDINATES TO RETINAL ANGLES
    [azimuth_retinal, eccentricity_retinal] =rPixel2rAngle(coords_retinal_rows,coords_retinal_cols,ifix,jfix,M,N,vAngle_retina, lambda);
    
    %RETINAL ANGLES TO VISUAL ANGLES
    [azimuth_visual,eccentricity_visual] = rAngle2vAngle(azimuth_retinal,eccentricity_retinal, lambda, e0);
    
    %VISUAL ANGLES TO VISUAL PIXELS
    [coords_image_rows, coords_image_cols] = vAngle2vPixel(azimuth_visual,eccentricity_visual,ifix, jfix, M, N, vAngle_image,lambda);
        
    %ROUND PIXEL COORDINATES, DOUBLES TO INTEGERS
    coords_image_rows = round(coords_image_rows);
    coords_image_cols = round(coords_image_cols);
    
    %FROM PIXEL COORDINATES OF RETINA TO VISUAL
    retinal_image = recoord2(image,coords_image_rows,coords_image_cols);
    
    

end
