function [ azimuth_visual, eccentricity_visual  ] = rAngle2vAngle( azimuth_retinal, eccentricity_retinal, lambda, e0)


eccentricity_visual = (eccentricity_retinal .* lambda)./(eccentricity_retinal + e0);

azimuth_visual = azimuth_retinal;

end

