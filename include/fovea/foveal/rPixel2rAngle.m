function [ azimuth_retinal, eccentricity_retinal ] = rPixel2rAngle( X, Y , Xfix, Yfix, M, N, vAngle)

    Xrel = X - Xfix;
    Yrel = Y - Yfix;
    
    [theta,rho] = cart2pol(Xrel,Yrel);
    
    %[azimuth_retinal,eccentricity_retinal] = pol2eye(theta,rho,M,N,vAngle);
        %azimuth = theta to degrees
        azimuth_retinal = theta*(180/pi);
        %e = eccentricity in retinal angles
        max_r = sqrt(M^2 + N^2);
        eccentricity_retinal = (rho/max_r)*vAngle;
    
end

