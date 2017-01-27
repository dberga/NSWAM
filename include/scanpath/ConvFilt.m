function [filtimagepad] = ConvFilt(origimage,kernel,ksize)

[h,w] = size(origimage);

%Pad image
origimagepad = epadimage(origimage, ksize);

%Embed kernel in image that is size of original image + padding
[h1, w1] = size(origimagepad);
kernelimagepad = zeros(h1,w1);

kernelimagepad(1:ksize, 1:ksize) = kernel;

%Perform 2D FFTs
fftimagepad = fft2(origimagepad);
fftkernelpad = fft2(kernelimagepad);

%fftkernelpad(find(fftkernelpad == 0)) = 1e-6;

%Multiply FFTs
filtimagepad = fftimagepad.*fftkernelpad;

%Perform Reverse 2D FFT
filtimagepad = ifft2(filtimagepad);

%filtimagepad(find(filtimagepad <= 1e-16)) = 0;

%Remove Padding
filtimagepad = filtimagepad(ksize+1:ksize+h,ksize+1:ksize+w);


end
