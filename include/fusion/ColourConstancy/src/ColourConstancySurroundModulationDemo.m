% This script runs our model (Adaptive Surround Modulation) against four
% sample files.
%

%%
im1 = imread('00580.jpg');
im1 = double(im1) ./ 255;
[ColourConstantImage, luminance] = ColourConstancySurroundModulation(im1);
figure;
subplot(1, 2, 1), imshow(im1); title('Original image');
subplot(1, 2, 2), imshow(ColourConstantImage); title('Colour corrected image');

%%
im2 = imread('yellowtable.png');
im2 = double(im2) ./ 255;
[ColourConstantImage, luminance] = ColourConstancySurroundModulation(im2);
figure;
subplot(1, 2, 1), imshow(im2); title('Original image');
subplot(1, 2, 2), imshow(ColourConstantImage); title('Colour corrected image');

%%
im3 = imread('06030.jpg');
im3 = double(im3) ./ 255;
[ColourConstantImage, luminance] = ColourConstancySurroundModulation(im3);
figure;
subplot(1, 2, 1), imshow(im3); title('Original image');
subplot(1, 2, 2), imshow(ColourConstantImage); title('Colour corrected image');

%%
im4 = imread('cat.png');
im4 = double(im4) ./ 255;
[ColourConstantImage, luminance] = ColourConstancySurroundModulation(im4);
figure;
subplot(1, 2, 1), imshow(im4); title('Original image');
subplot(1, 2, 2), imshow(ColourConstantImage); title('Colour corrected image');
