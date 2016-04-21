function [ i,j ] = Cortex2Image( X,Y, M, N, icenter, jcenter, e0, lambda, vAngle)
    
    [e,azimuth] = Cortex2Polar(X,Y,e0,lambda);
    
    [theta,rho] = eye2pol(azimuth,e,M,N,vAngle);
        
    [irel,jrel] = pol2cart(theta,rho);

    i = irel + icenter;
    j = jrel + jcenter;
    
end

