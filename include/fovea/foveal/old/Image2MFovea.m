function [ X, Y] = Image2MFovea(i, j, M, N, icenter, jcenter, e0, lambda, vAngle )

    irel = i - icenter;
    jrel = j - jcenter;


    [theta,rho] = cart2pol(irel,jrel);
    
    [azimuth,e] = pol2eye(theta,rho,M,N,vAngle);
        
    [MFactor] = mag_factor(e,e0,lambda);
    
    [X,Y] = MFactor_to_coords(MFactor,irel,jrel,lambda);
        %e_mag = e_magnify(MFactor,e);
        %[theta_mag,rho_mag] = eye2pol(azimuth,e_mag,M,N,vAngle);
        %[X,Y] = pol2cart(theta,rho_mag);

end
