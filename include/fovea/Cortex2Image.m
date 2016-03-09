function [ i,j ] = Cortex2Image( X,Y, M, N, icenter, jcenter, e0, lambda, vAngle)
    
    [e,azimuth] = Cortex2Polar(X,Y,e0,lambda);
    
        %theta = azimuth to radians
        theta = azimuth*(pi/180);
        %rho = eccentricity distance relative to visual angle
        max_r = sqrt(M^2 + N^2);
		rho = (e*max_r)/vAngle;
        
    [irel,jrel] = pol2cart(theta,rho);

    i = irel + icenter;
    j = jrel + jcenter;
    
end

