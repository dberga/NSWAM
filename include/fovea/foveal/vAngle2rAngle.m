function [ azimuth_retinal, eccentricity_retinal ] = vAngle2rAngle(azimuth_visual, eccentricity_visual, gamma )


eccentricity_retinal = (1/gamma).*(eccentricity_visual.^(gamma));
%eccentricity_retinal = eccentricity_visual.*(gamma);

azimuth_retinal = azimuth_visual;

end

