function [ image_hleft, image_hright ] = undistort_cortex( cortex, ifix, jfix, vAngle_image, lambda,e0 )

    [M,N,C] = size(cortex);
       
    
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
    
    cortex_hleft = cortex(:,1:jfix);
    cortex_hright = cortex(:,jfix+1:end);
    
    %GET CORRESPONDENCE COORDINATES OF IMAGE (M,N) matrix
    [coords_image_cols,coords_image_rows] = meshgrid(1:N,1:M);
    
    
    %RETINAL ANGLES TO CORTICAL COORDINATES
    cols = coords_image_cols-jfix;
    fils = coords_image_rows-ifix;
    
    
     %COORDINATES TO ECCENTRICITY AND AZIMUTH
     [theta,rho] = cart2pol(cols,fils);
     U = rho; %in pixels
     U_hleft=U(:,1:jfix);
     U_hright=U(:,jfix+1:end);
     V = theta; %in rad
     V_q1 = V(1:ifix-1,jfix+1:end); V_q1 = -V_q1;
     V_q2 = V(1:ifix-1,1:jfix); V_q2 = -V_q2;
     V_q3 = V(ifix:end,1:jfix); V_q3 = -mod(V_q3,-2*pi);
     V_q4 = V(ifix:end,jfix+1:end); V_q4 = mod(-V_q4,pi*2);
     V_hleft = [V_q2 ; V_q3];
     V_hright = [V_q1 ; V_q4];
     
     
     %CALCULATE NEW X and Y
     [eccentricity_hleft,azimuth_hleft] = cortex2eye(V_hleft,U_hleft,e0,lambda,2);
     [eccentricity_hright,azimuth_hright] = cortex2eye(V_hright,U_hright,e0,lambda,2);

     %REAL X AND IMAGINARY Y TO COORDINATES
     [cols_hleft,fils_hleft] = pol2cart(azimuth_hleft,eccentricity_hleft);
     [cols_hright,fils_hright] = pol2cart(azimuth_hright,eccentricity_hright);
     
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
     image_hleft = recoord2(cortex,fils_hleft,cols_hleft);
     image_hright = recoord2(cortex,fils_hright,cols_hright);

     
  
end

