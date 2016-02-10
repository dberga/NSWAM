function I = gabor_tai_sing_lee(size, orientation, even)
%gabor(size, orientation,even) generates a gabor wavelet
%of size x size in spatial support, orientation (in degree)
%and either even or odd symmetric in phase. (even=1 or 0).
%other is specified in Lee, PAMI 1996.
%sigma = kernel size/6
%frequency and orientation bandwidth depends on sigma (equation 10)
%sigma used in paper 1,2,4,8,16,32,64
%spacing delta x = sigma 
%e.g. try gabor(32, 0, 1) and see...

sigma = size/9;
lambda = (size * 1.5 * pi)/15;
f = (2*pi)/lambda;
if (orientation ~= 0) k = orientation/3;
else k = orientation;
end
theta = (pi * k)/60;
u = f * cos(theta);
v = f * sin(theta);
c = size/2;
gabor_f = ones(size,size);
Gaus = zeros(size,size);
for i = 1:size
  for j = 1:size
    ai = (i-c) * cos(theta) + (j-c) * sin(theta);
    aj = (i-c) * -sin(theta) + (j-c) * cos(theta);
    Gaus(i,j) = exp(-(1/(8*sigma^2))*(4 * ai^2 + aj^2));
    gabor_f(i,j) = Gaus(i,j) * sin(u *  (i-c) + v * (j-c) + (even * pi/2));
  end
end

colormap(gray(255));
I = uint8(255*((gabor_f++1.0)/2));
imshow(I)
