function [ azimuth,eccentricity ] = pol2eye( theta,rho,M,N,vAngle,lambda)

        %azimuth = theta to angle
        %azimuth = theta*(180/pi);
        azimuth = theta;
        %e = relative to visual angle and image
        %max_r = sqrt(M^2 + N^2);
        %eccentricity = (rho/max_r)*vAngle;
        eccentricity = rho;

end

