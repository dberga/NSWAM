function img = opponent2rgb_new(opp_img, gamma, srgb_flag)


switch srgb_flag
    case -1
        %no opponents, keep rgb
        img = opp_img;
    case 0
        %opponents, no gamma correction
        img = opponent2rgb_plain(opp_img);
        img = renorm_img(img);
        
    case 1
        %opponents, yes gamma correction
        img = opponent2rgb_plain(opp_img);
        img = decorrect_gamma(img, gamma);
        img = renorm_img(img);
    otherwise
        %no opponents, keep rgb
        img = opp_img;

end


end





% Converts rgb values into opponent color values.
%
% outputs:
%   opp_img: opponent image
% 
% inputs:
%   img: s/rgb image with values between 0 and 255 or between 0 and 1
%   gamma: gamma value for gamma correction
%   srgb_flag: 0 if img is rgb; 1 if img is srgb
function img = opponent2rgb_plain(opp_img)

O12=opp_img(:,:,1);
O23=opp_img(:,:,2);
O3=opp_img(:,:,3);

img(:,:,3)=O3.*(1-O23)/3.0;
img(:,:,2)=(O3-img(:,:,3)-O3.*O12)*0.5;
img(:,:,1)=O3.*O12+img(:,:,2);

end


function c_img = decorrect_gamma(img, gamma)
    img_sRGB_temp1 = (img*12.92).*(img <= 0.0031308);
    img_sRGB_temp2 = ((1+0.055)*(img.^(1/gamma))-0.055).*(img > 0.0031308);
    img_sRGB       = img_sRGB_temp1 + img_sRGB_temp2;

    c_img = img_sRGB;
end

function n_img = renorm_img(img)

    n_img = img*255;
end


