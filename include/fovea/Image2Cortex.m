function [ X, Y] = Image2Cortex(i, j, M, N, icenter, jcenter, e0, lambda, vAngle )

    irel = i - icenter;
    jrel = j - jcenter;


    [theta,rho] = cart2pol(irel,jrel);
        %azimuth = theta to angle
        azimuth = theta*(180/pi);
        %e = relative to visual angle and image
        max_r = sqrt(M^2 + N^2);
        e = (rho/max_r)*vAngle;
        
        
    [X,Y,~] = Polar2Cortex(e,azimuth,e0,lambda);

end
