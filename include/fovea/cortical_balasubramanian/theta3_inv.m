function [ azimuth ] = theta3_inv( theta3, alpha1, alpha2, alpha3 )

zerop = 0 + abs(eps);
zeron = 0 - abs(eps);

%case  azimuth <= pi/2 && azimuth >= zerop
azimuthp = (-(pi*alpha1) + (2*alpha2*zerop)+(pi*alpha2)+(2*theta3)) ./ (2*alpha3);

%case azimuth <= zeron && azimuth >= -pi/2
azimuthn = ((pi*alpha1) + (2*alpha2*zeron)-(pi*alpha2)+(2*theta3)) ./ (2*alpha3);


if azimuthp <= pi/2 & azimuthp >= zerop
    azimuth = azimuthp;
elseif azimuthn <= zeron & azimuthn >= -pi/2
    azimuth = azimuthn;
else
    azimuth = theta3;
end


end

