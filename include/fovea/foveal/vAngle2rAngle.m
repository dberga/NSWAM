function [ azimuth_retinal, eccentricity_retinal ] = vAngle2rAngle(azimuth_visual, eccentricity_visual, gamma , e0)




eccentricity_retinal = - (eccentricity_visual.*e0) ./ (eccentricity_visual- gamma);

 
azimuth_retinal = azimuth_visual;

end

