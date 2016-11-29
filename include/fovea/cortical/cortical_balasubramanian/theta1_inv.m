function [ azimuth ] = theta1_inv( theta1, alpha1 )

zerop = 0 + abs(eps);
zeron = 0 - abs(eps);

azimuth =  theta1 ./ alpha1;

end

