function [ e ] = mag_factor_inv( MFactor, e0, lambda )


    e = (lambda -  MFactor*e0 ) ./ MFactor ;
        
end

