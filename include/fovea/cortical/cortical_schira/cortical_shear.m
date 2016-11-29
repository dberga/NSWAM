function [ f_angle ] = cortical_shear( eccentricity, azimuth, angle, eccWidth,isoPolarGrad )

f_angle = real((sech(azimuth) .^ sech(log(eccentricity/angle)*eccWidth)*isoPolarGrad));

end

