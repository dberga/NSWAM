function [ i, j ] = vAngle2vPixel(azimuth_visual, eccentricity_visual, ifix,jfix, M,N,vAngle_image,lambda )

    [theta,rho] = eye2pol(azimuth_visual,eccentricity_visual,M,N,vAngle_image);

    [irel,jrel] = pol2cart(theta,rho);
    
    i = irel + ifix;
    j = jrel + jfix;

end






%         if ifix == jfix
%             max_m = ifix;
%             max_n = jfix;
%         else
%             max_m = max([abs(M-ifix) abs(1-ifix)]);
%             max_n = max([abs(M-ifix) abs(1-jfix)]);
%             
%         end
%        max_r = round(sqrt(max_m^2 + max_n^2));