function [ e, azimuth ] = Cortex2Polar( X, Y, e0, lambda )


    e=e0.*(exp(X./lambda)-1);
    azimuth = - (180.*Y.*exp(X./lambda))./ (pi.*lambda - pi.*lambda.*exp(X./lambda));

    %%avoid 0/0 or n/0
        %if X == 0
        %	azimuth = 0;
        %end

    %%avoid to output angles larger than 360
        %voltes = floor(azimuth/360);
        %azimuth = azimuth - (voltes)*360;

        %voltes = floor(e/360);
        %e = e - (voltes)*360;

    
    
    
end

