function [ azimuth_visual, eccentricity_visual  ] = rAngle2vAngle( azimuth_retinal, eccentricity_retinal, gamma)


eccentricity_visual = (eccentricity_retinal .* gamma).^(1/gamma);
%eccentricity_visual = eccentricity_retinal ./ gamma;

azimuth_visual = azimuth_retinal;

end

