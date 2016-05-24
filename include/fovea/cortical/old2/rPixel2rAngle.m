function [ azimuth_retinal, eccentricity_retinal ] = rPixel2rAngle( X, Y , Xfix, Yfix, M, N, vAngle_retina,lambda)

    Xrel = X - Xfix;
    Yrel = Y - Yfix;
    
    [theta,rho] = cart2pol(Xrel,Yrel);
    
    [azimuth_retinal,eccentricity_retinal] = pol2eye(theta,rho,M,N,vAngle_retina,lambda);
        
        
end








%         if Yfix == Xfix
%             max_m = Yfix;
%             max_n = Xfix;
%             
%         else
%             max_m = max([abs(M-Yfix) abs(1-Yfix)]);
%             max_n = max([abs(M-Yfix) abs(1-Yfix)]);
%             max_r = sqrt(max_m^2 + max_n^2);
%         end
%         max_r = sqrt(max_m^2 + max_n^2);