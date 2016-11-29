function [ shifted_eccentricity, shifted_azimuth ] = cortical_shift( eccentricity, azimuth, shiftAmount )

if abs(azimuth) < pi/2
    shift = shiftAmount;
else
    shift = 2 * (azimuth*(1/pi)+1) * shiftAmount;
end

shifted_eccentricity = sqrt(((eccentricity.*(cos(azimuth).^2) +shift).^2) + ((eccentricity.*(sin(azimuth).^2)).^2));
shifted_azimuth = atan2((eccentricity*sin(azimuth))./(eccentricity*cos(azimuth) + shift));

end

