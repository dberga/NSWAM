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







function n_img = denorm_img(img)
    
    if max(img(:)) > 1
        n_img = img/255;
    else
        n_img= img;
    end
end


