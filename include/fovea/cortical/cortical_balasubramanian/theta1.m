function [ theta1 ] = theta1( azimuth, alpha1 )

zerop = 0 + abs(eps);
zeron = 0 - abs(eps);

theta1 = azimuth .* alpha1;

end

