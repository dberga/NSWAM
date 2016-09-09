function [ azimuth_visual, eccentricity_visual ] = vPixel2vAngle( i, j, ifix, jfix, M, N, vAngle_image ,lambda)

    
irel = i - ifix;
jrel = j - jfix;
    
[theta,rho] = cart2pol(irel,jrel);

%[azimuth_visual,eccentricity_visual] = pol2eye(theta,rho,M,N,vAngle);
        %azimuth = theta to degrees
        azimuth_visual = theta*(180/pi);
        %e = eccentricity in visual angles
        max_r = sqrt(M^2 + N^2);
        eccentricity_visual = (rho/max_r)*vAngle_image;   

end

