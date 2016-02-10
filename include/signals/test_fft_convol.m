
tic


img=double(imread('cameraman.tif'));

figure,imagesc(img);colormap('gray');


alc=size(img,1);
ampl=size(img,2);

% psf=double([1 1 1; 1 1 1; 1 1 1]);

Delta=5;

psf=ones(2*Delta+1,2*Delta+1);

img_pad=padarray(img,[Delta Delta]);


	% FFT

img_fft=fftn(img_pad);
psf_fft=fftn(psf, [alc+2*Delta ampl+2*Delta]);

conv_fft=img_fft.*psf_fft;

conv_img_fft=ifftn(conv_fft,'symmetric');

conv_img_fft=circshift(conv_img_fft,[-Delta -Delta]);


	% CONVN

conv_img_conv=convn(img_pad,psf,'same');




dif=conv_img_fft-conv_img_conv;

figure,imagesc(conv_img_fft);colormap('gray');
figure,imagesc(conv_img_conv);colormap('gray');
figure,imagesc(dif);colormap('gray');

toc