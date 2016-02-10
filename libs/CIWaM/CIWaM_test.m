% img=imread('peppers.png');
img=imread('mandril.tif');

figure,imshow (img);


% nPlans=4;

mida_min=4; % Ha de ser potencia de dos. No recomano que sigui 1 ;)
nPlans=floor(log(max(size(img(:,:,1))-1)/mida_min)/log(2)) + 1

window_sizes=[3 6];
nu_0=3;

ind=CIWaM(img, window_sizes, nPlans, 1, 0, nu_0);

figure,imshow(uint8(ind));