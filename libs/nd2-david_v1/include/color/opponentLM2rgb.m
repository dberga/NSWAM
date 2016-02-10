function img = opponentLM2rgb(opp_img, gamma, srgb_flag)
% Converts rgb values into opponent color values.
%
% outputs:
%   opp_img: opponent image
% 
% inputs:
%   img: s/rgb image with values between 0 and 255 or between 0 and 1
%   gamma: gamma value for gamma correction
%   srgb_flag: 0 if img is rgb; 1 if img is srgb




% We assume white light. Therefore, we use the simplified version of
% opponent color transform


%opp_img(:,:,1) = O13;
%opp_img(:,:,2) = O23;
%opp_img(:,:,3) = O3;

img(:,:,1)=opp_img(:,:,1);
img(:,:,1)=0;
indexRG = find (opp_img(:,:,1)>0.001);
img1=img(:,:,1);
opp_img3=opp_img(:,:,3);
opp_img1=opp_img(:,:,1);
img1(indexRG) = opp_img3(indexRG)./ (1+1./opp_img1(indexRG));

img(:,:,1)=img1;
img(:,:,2)=opp_img(:,:,3)-img(:,:,1);
img(:,:,3)=opp_img(:,:,2).*opp_img(:,:,3);



% img(:,:,1)=1/3+opp_img(:,:,1).*0.5+opp_img(:,:,2).*1/6;
% img(:,:,2)=1/3-opp_img(:,:,1).*0.5+opp_img(:,:,2).*1/6;
% img(:,:,3)=1/3-opp_img(:,:,2).*1/3;
% 
% img(:,:,1)=img(:,:,1).*opp_img(:,:,3);
% img(:,:,2)=img(:,:,2).*opp_img(:,:,3);
% img(:,:,3)=img(:,:,3).*opp_img(:,:,3);


if srgb_flag
    % perform gamma correction:
    img_sRGB_temp1 = (img*12.92).*(img <= 0.0031308);
    img_sRGB_temp2 = ((1+0.055)*(img.^(1/gamma))-0.055).*(img > 0.0031308);
    img_sRGB       = img_sRGB_temp1 + img_sRGB_temp2;

    img = img_sRGB;
end


% normalise RGB values if necessary:
%if max(img(:)) > 1
%    img = img/255;
%end

img = img*255;

%img = uint8(img);
