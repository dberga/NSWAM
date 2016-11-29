function [ theta2 ] = theta2( azimuth, alpha1, alpha2 )

zerop = 0 + abs(eps);
zeron = 0 - abs(eps);

if azimuth <= pi/2 && azimuth >= zerop
    theta2 = -alpha2 .* (azimuth + pi/2) + theta1(pi/2, alpha1);
elseif azimuth <= zeron && azimuth >= -pi/2
        theta2 = -alpha2 .* (azimuth - pi/2) + theta1(-pi/2, alpha1);
else 
    %outside of V2
    theta2 = azimuth;
end




end

