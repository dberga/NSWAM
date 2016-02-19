function [ output_image ] = distort_fisheye( input_image, cx, cy, scaling, exponent)




ncols = size(input_image,2);
nrows = size(input_image,1);

if nargin < 2
    
    cx = round(ncols/2);
    cy = round(nrows/2);
    exp = 3;
    scaling = ncols/2;
    sx = scaling;
    sy = scaling*(nrows/ncols);
else
    
    sx = scaling;
    sy = scaling*(nrows/ncols);
    exp = exponent;
    
end





options = [cx cy sx sy exp];  %# An array containing the columns, rows, and exponent
han = @fisheye;
tf = maketform('custom',2,2,[],han,options);
output_image = imtransform(input_image,tf);  %# Transform the image


end

