function [ theta,rho ] = eye2pol( azimuth,eccentricity,M,N,vAngle,lambda )
        %theta = azimuth to radians
        theta = azimuth*(pi/180);
        %rho = eccentricity distance relative to visual angle
        max_r = sqrt(M^2 + N^2);
		rho = (eccentricity*max_r)/vAngle;

end

