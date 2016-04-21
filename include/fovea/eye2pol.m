function [ theta,rho ] = eye2pol( azimuth,e,M,N,vAngle )
        %theta = azimuth to radians
        theta = azimuth*(pi/180);
        %rho = eccentricity distance relative to visual angle
        max_r = sqrt(M^2 + N^2);
		rho = (e*max_r)/vAngle;

end

