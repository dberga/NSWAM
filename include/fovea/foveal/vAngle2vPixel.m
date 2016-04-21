function [ i, j ] = vAngle2vPixel(azimuth_visual, eccentricity_visual, ifix,jfix, M,N,vAngle )

    %[theta,rho] = eye2pol(azimuth_visual,eccentricity_visual,M,N,vAngle);
        %theta = azimuth to radians
        theta = azimuth_visual*(pi/180);
        %rho = distance relative to visual angle
        max_r = sqrt(M^2 + N^2);
		rho = (eccentricity_visual*max_r)/vAngle;
        
    [irel,jrel] = pol2cart(theta,rho);
    
    i = irel + ifix;
    j = jrel + jfix;

end

