function [ X, Y] = Image2Cortex(i, j, M, N, icenter, jcenter, e0, lambda, vAngle )

    irel = i - icenter;
    jrel = j - jcenter;

    
    [theta,rho] = cart2pol(irel,jrel);
    
    [azimuth,e] = pol2eye(theta,rho,M,N,vAngle);
        
    [X,Y,~] = Polar2Cortex(e,azimuth,e0,lambda);

end
