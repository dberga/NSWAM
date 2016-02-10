
function [] = saliency_naila(input_image,image_name)

%set output parameters
output_folder = 'output';
output_image = ['sal_' image_name];
experiment_name = 'image_name';


[m n p]      = size(input_image);
nu_0         = 4;                                % peak spatial frequency of CSF; suggested value of 4
window_sizes = [13 26];                          % window sizes for computing relative contrast
wlev         = min([7,floor(log2(min([m n])))]); % number of wavelet planes
gamma        = 2.4;                              % gamma value for gamma correction
srgb_flag    = 1;                                % 0 if img is rgb; 1 if img is srgb

% get saliency map:
fmap = SWAM(input_image, window_sizes, wlev, gamma, srgb_flag, nu_0);

%plot output
    %figure; 
    %subplot(1,2,1); imshow(uint8(input_image)); 
    %subplot(1,2,2); imshow(fmap,[]); 
    %imagesc(fmap);
        %colormap('gray');

        %disp(fmap);
%write output image on output folder
imwrite(uint8(fmap),[output_folder '/' 'naila_' output_image]);


end

