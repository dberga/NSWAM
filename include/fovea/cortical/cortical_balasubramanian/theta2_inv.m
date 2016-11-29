function [ azimuth ] = theta2_inv( theta2, alpha1, alpha2 )

zerop = 0 + abs(eps);
zeron = 0 - abs(eps);

%case  azimuth <= pi/2 && azimuth >= zerop
azimuthp = (-(pi*alpha1) + (pi*alpha2)+(2*theta2)) ./ (2*alpha2);

%case azimuth <= zeron && azimuth >= -pi/2
azimuthn = -((pi*alpha1) - (pi*alpha2)+(2*theta2)) ./ (2*alpha2);


if azimuthp <= pi/2 & azimuthp >= zerop
    azimuth = azimuthp;
elseif azimuthn <= zeron & azimuthn >= -pi/2
    azimuth = azimuthn;
else
    azimuth = theta2;
end

end

