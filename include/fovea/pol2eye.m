function [ azimuth,e ] = pol2eye( theta,rho,M,N,vAngle)

        %azimuth = theta to angle
        azimuth = theta*(180/pi);
        %e = relative to visual angle and image
        max_r = sqrt(M^2 + N^2);
        e = (rho/max_r)*vAngle;
        

end

