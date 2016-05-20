function [ cortex_hleft, cortex_hright ] = distort_cortex( image, ifix, jfix, vAngle_image, lambda,e0 )

    [M,N,C] = size(image);
       
    
    %DEFAULT PARAMETERS (IF NOT SET)
    if nargin < 7

       vAngle_image = 60;
       vAngle_retina = 10;
       lambda = 1.2;
       e0= 1;
       
       if nargin < 4
           ifix = round(M/2); %center
           jfix = round(N/2); %center
       end
    end
    
    image_hleft = image(:,1:jfix);
    image_hright = image(:,jfix+1:end);
    
    %GET CORRESPONDENCE COORDINATES OF IMAGE (M,N) matrix
    [coords_cortical_cols,coords_cortical_rows] = meshgrid(1:N,1:M);
    
    
    %RETINAL ANGLES TO CORTICAL COORDINATES
    cols = coords_cortical_cols-jfix;
    fils = coords_cortical_rows-ifix;
    
    
     %COORDINATES TO ECCENTRICITY AND AZIMUTH
     [theta,rho] = cart2pol(cols,fils);
     eccentricity = rho; %in pixels
     eccentricity_hleft=eccentricity(:,1:jfix);
     eccentricity_hright=eccentricity(:,jfix+1:end);
     azimuth = theta; %in rad
     azimuth_q1 = azimuth(1:ifix-1,jfix+1:end); azimuth_q1 = -azimuth_q1;
     azimuth_q2 = azimuth(1:ifix-1,1:jfix); azimuth_q2 = -azimuth_q2;
     azimuth_q3 = azimuth(ifix:end,1:jfix); azimuth_q3 = -mod(azimuth_q3,-2*pi);
     azimuth_q4 = azimuth(ifix:end,jfix+1:end); azimuth_q4 = mod(-azimuth_q4,pi*2);
     azimuth_hleft = [azimuth_q2 ; azimuth_q3];
     azimuth_hright = [azimuth_q1 ; azimuth_q4];
     
     
     %CALCULATE NEW X and Y
     [U_hleft,V_hleft] = eye2cortex(azimuth_hleft,eccentricity_hleft,e0,lambda,1);
     [U_hright,V_hright] = eye2cortex(azimuth_hright,eccentricity_hright,e0,lambda,1);

     %REAL X AND IMAGINARY Y TO COORDINATES
     [cols_hleft,fils_hleft] = pol2cart(V_hleft,U_hleft);
     [cols_hright,fils_hright] = pol2cart(V_hright,U_hright);
     
     %REMOVE OUTLIERS (ex. log(0)=-inf)
     cols_hleft = remove_outliers(cols_hleft);
     fils_hleft = remove_outliers(fils_hleft);
     cols_hright = remove_outliers(cols_hright);
     fils_hright = remove_outliers(fils_hright);
     
     %COORDS FROM RHO -5..5,-5...5 TO 1...N,1...M
     cols_hleft = normalize_spec(cols_hleft,1,N/2);
     fils_hleft = normalize_spec(fils_hleft,1,M);
     cols_hright = normalize_spec(cols_hright,N/2,N);
     fils_hright = normalize_spec(fils_hright,1,M);

     
     
     %ROUND COORDS
     cols_hleft = round(cols_hleft);
     fils_hleft = round(fils_hleft);
     cols_hright = round(cols_hright);
     fils_hright = round(fils_hright);
     
     %FROM PIXEL COORDINATES OF RETINA TO VISUAL
     cortex_hleft = recoord2(image,fils_hleft,cols_hleft);
     cortex_hright = recoord2(image,fils_hright,cols_hright);

     
  
end
