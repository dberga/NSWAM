function [ densityMap ] = imgSalGaussian( fixMap, hSize, sigma )

if ~exist('hSize','var') hSize = 40; end  
if ~exist('sigma','var') sigma = 10; end
    
densityMap = imfilter(fixMap,fspecial('gaussian',hSize,sigma),'replicate');

end

