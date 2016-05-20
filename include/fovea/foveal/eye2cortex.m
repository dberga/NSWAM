function [ U,V ] = eye2cortex( azimuth,eccentricity, e0, lambda , method)

if nargin < 5
method =2;
end

switch method
    case 1
    %ZLI
    U = lambda .* log(1+ (eccentricity./e0));
    V=-(lambda .* eccentricity .* azimuth .* pi)./((e0+eccentricity).*180);
    W = U + 1j.*V;
    z = (eccentricity./e0) .* exp ( -1j .* ((pi.*azimuth) ./ 180));
    
    otherwise
    %Schwartz
    z = eccentricity.*exp(1j.*azimuth);
    
    %Z = log(z+1); 
    W=log1p(z);
    U=real(W); 
    V= imag(W); 

end

end

