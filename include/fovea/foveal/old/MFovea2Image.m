function [ i,j ] = MFovea2Image( X,Y, M, N, icenter, jcenter, e0, lambda, vAngle)
    

        
        [theta_mag,rho_mag] = cart2pol(X,Y);
        
        [azimuth_mag,e_mag] = pol2eye(theta_mag,rho_mag,M,N,vAngle);
        
        
        %[MFactor] = mag_factor(e_mag,e0,lambda);        
        %e = e_magnify_inv(MFactor,e_mag);
        %[theta,rho] = eye2pol(azimuth_mag,e,M,N,vAngle);
        
        
        
    [irel,jrel] = pol2cart(theta,rho);

    i = irel + icenter;
    j = jrel + jcenter;
    
    
end

