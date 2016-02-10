function opp_img = rgb2opponent_new(img, gamma, srgb_flag)

img = double(img);

switch srgb_flag
    case -1
        %no opponents, keep rgb
        opp_img = img;
    case 0
        %opponents, no gamma correction
        img = denorm_img(img);
        opp_img = rgb2opponent_plain(img);
    case 1
        %opponents, yes gamma correction
        img = denorm_img(img);
        img = correct_gamma(img, gamma);
        opp_img = rgb2opponent_plain(img);
    otherwise
        %no opponents, keep rgb
        opp_img = img;

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



function opp_img = rgb2opponent_plain(img)

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

O1 = R-G;
O2 = R+G-2*B;
O3 = R+G+B;

O13 = O1;
O23 = O2;

% For intensity-normalized chromatic channel
O13 = O1./O3;
O23 = O2./O3;

O13(isnan(O13)) = 0;
O23(isnan(O23)) = 0;

opp_img(:,:,1) = O13;
opp_img(:,:,2) = O23;
opp_img(:,:,3) = O3;

end


function c_img = correct_gamma(img, gamma)
    img_sRGB_temp1 = (img/12.92).*(img <= 0.04045);
    img_sRGB_temp2 = (((img + 0.055)/1.055).^gamma).*(img > 0.04045);
    img_sRGB       = img_sRGB_temp1 + img_sRGB_temp2;
    c_img = img_sRGB;
end

function n_img = denorm_img(img)
    
    if max(img(:)) > 1
        n_img = img/255;
    end
end


