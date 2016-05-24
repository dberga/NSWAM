function [ azimuth_retinal, eccentricity_retinal ] = vAngle2rAngle(azimuth_visual, eccentricity_visual, lambda , e0)

 
 
 
    %eccentricity_retinal = - (eccentricity_visual.*e0) ./ (eccentricity_visual- lambda);
    
    %eliminar valores fuera del lambda (e_visual > lambda), mirroring
    %condit = eccentricity_retinal > 0;
    %condit = double(condit); 
    %condit(condit==0) = -inf;
    %eccentricity_retinal = condit.*eccentricity_retinal;
 
     %eccentricity_retinal = lambda .* log(eccentricity_visual+e0);
     eccentricity_retinal =  log(eccentricity_visual+e0);
    %eccentricity_retinal = exp(eccentricity_visual ./ lambda) - e0;
    
azimuth_retinal = azimuth_visual;

end

