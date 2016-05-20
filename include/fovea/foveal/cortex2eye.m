function [ eccentricity, azimuth ] = cortex2eye( V, U, e0, lambda, method )

if nargin < 5
method =2;
end

switch method
    case 1
%ZLI


    eccentricity = e0 .* (exp(U./lambda)-1);
    azimuth = -(V .* 180 .* (eccentricity + e0))./(lambda .* pi .* eccentricity);
    
    otherwise
%Schwartz
    W = U + (1j.*V); %Z = w = u + v*i
    z = expm1(W); 
    %z = exp(Z) -1;
    
    eccentricity= real(z);
    azimuth= imag(z);
    



end

end

