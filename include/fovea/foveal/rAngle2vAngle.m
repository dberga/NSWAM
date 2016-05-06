function [ azimuth_visual, eccentricity_visual  ] = rAngle2vAngle( azimuth_retinal, eccentricity_retinal, lambda, e0)


%eccentricity_visual = exp(eccentricity_retinal ./ lambda) - e0;
eccentricity_visual = exp(eccentricity_retinal) - e0;
%eccentricity_visual = (exp(eccentricity_retinal) -1)*e0;


azimuth_visual = azimuth_retinal;

end

