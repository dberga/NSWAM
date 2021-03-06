function [ image ] = undistort_fovea( retinal_image , ifix, jfix, vAngle_image , lambda, e0)


    [M,N,C] = size(retinal_image);
    
    %default parameters if not set
    if nargin < 7

       vAngle_image = 60;
       
       %max_r = sqrt(M*M+N*N);
%        lambda = sqrt(M*M+N*N)/vAngle_retina
        %vAngle_retina = 3*vAngle_image;
       %lambda = max_r/vAngle_retina;
       vAngle_retina = 10;
       lambda = 1.2;
       e0= 1;
       
       if nargin < 4
           ifix = round(M/2); %center
           jfix = round(N/2); %center
       end
    end
    
    
    %GET CORRESPONDENCE COORDINATES OF IMAGE (pM,pN) matrix
    [coords_image_cols,coords_image_rows] = meshgrid(1:N,1:M);
    
    %VISUAL COORDINATES TO VISUAL ANGLES
    [azimuth_visual, eccentricity_visual] =vPixel2vAngle(coords_image_rows,coords_image_cols,ifix,jfix,M,N,vAngle_image,lambda);
    
    %VISUAL ANGLES TO RETINAL ANGLES
    [azimuth_retinal,eccentricity_retinal] = vAngle2rAngle(azimuth_visual,eccentricity_visual, lambda, e0);
    
    %RETINAL ANGLES TO RETINAL PIXELS
    [coords_retinal_rows, coords_retinal_cols] = rAngle2rPixel(azimuth_retinal,eccentricity_retinal,ifix, jfix, M, N, vAngle_retina,lambda);

        
    %ROUND PIXEL COORDINATES, DOUBLES TO INTEGERS
    coords_retinal_rows = round(coords_retinal_rows);
    coords_retinal_cols = round(coords_retinal_cols);
    
    
    
    %FROM PIXEL COORDINATES OF RETINA TO VISUAL, OR REVERSE, OR SAME
    image = recoord2(retinal_image,coords_retinal_rows, coords_retinal_cols);
    
    

    
end

