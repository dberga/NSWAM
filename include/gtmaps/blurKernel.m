function [ kernel ] = blurKernel( ksize, s )
%Blur Kernel
kernel = zeros(ksize);

%Gaussian Blur
m = ksize/2;
[X, Y] = meshgrid(1:ksize);
kernel = (1/(2*pi*s^2))*exp(-((X-m).^2 + (Y-m).^2)/(2*s^2));

end

