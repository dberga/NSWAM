function opp_img = rgb2opponentLM(img, gamma, srgb_flag)
% Converts rgb values into opponent color values.
%
% outputs:
%   opp_img: opponent image
% 
% inputs:
%   img: s/rgb image with values between 0 and 255 or between 0 and 1
%   gamma: gamma value for gamma correction
%   srgb_flag: 0 if img is rgb; 1 if img is srgb

img = double(img);

% normalise RGB values if necessary:
if max(img(:)) > 1
    img = img/255;
end

if srgb_flag
    % perform gamma correction:
    img_sRGB_temp1 = (img/12.92).*(img <= 0.04045);
    img_sRGB_temp2 = (((img + 0.055)/1.055).^gamma).*(img > 0.04045);
    img_sRGB       = img_sRGB_temp1 + img_sRGB_temp2;

    R = img_sRGB(:,:,1);
    G = img_sRGB(:,:,2);
    B = img_sRGB(:,:,3);
else
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);    
end

% We assume white light. Therefore, we use the simplified version of
% opponent color transform

O1=R;
O2=R;
O3=R;

O1(:,:) = 1.0;
indexG=find(G>0.001);
O1(indexG)= R(indexG)./G(indexG);

O3 = R+G;
indexO3 = find(O3>0.001);
O2(:,:) = 0.5;
O2 (indexO3)= B(indexO3)./O3(indexO3);


O1(isnan(O1)) = 0;
O2(isnan(O2)) = 0;

opp_img(:,:,1) = O1;
opp_img(:,:,2) = O2;
opp_img(:,:,3) = O3;
