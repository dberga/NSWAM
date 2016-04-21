function [ X, Y ] = rAngle2rPixel( azimuth_retinal, eccentricity_retinal, ifix, jfix, M, N, vAngle )

%[theta,rho] = eye2pol(azimuth_retinal,eccentricity_retinal,M,N,vAngle);
        %theta = azimuth to radians
        theta = azimuth_retinal*(pi/180);
        %rho = distance relative to visual angle
        max_r = sqrt(M^2 + N^2);
		rho = (eccentricity_retinal*max_r)/vAngle;
        
[X,Y] = pol2cart(theta,rho);
X = X + ifix;
Y = Y + jfix;


end

