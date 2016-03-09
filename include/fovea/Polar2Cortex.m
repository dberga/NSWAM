function [ X, Y, Z ] = Polar2Cortex( e, azimuth, e0, lambda )


    X = lambda * log( 1.0 + (e./e0));
    Y =  (lambda .* e .* azimuth .* pi) ./ ((e0 + e) .* 180);
    %z = (e / e0 )^(-(pi*azimuth/180)*1j);
    Z = X + Y*j;
    
end

