function [ theta3 ] = theta3( azimuth, alpha1, alpha2, alpha3 )

zerop = 0 + abs(eps);
zeron = 0 - abs(eps);

if azimuth <= pi/2 && azimuth >= zerop
    theta3 = alpha3 .* azimuth + theta2(zerop, alpha2);
elseif azimuth <= zeron && azimuth >= -pi/2
    theta3 = alpha3 .* azimuth + theta2(zeron, alpha2);
else 
    %outside of V2
    theta3 = azimuth;
end



end

