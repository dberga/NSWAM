function [ im_out ] = padding_zeros2mean( im_in , im_original, token)

if nargin < 3
    token = -inf;
end

[~,~,C] = size(im_in);
im_out = im_in;



media = mean(mean(im_original));

for c=1:C
im_out(im_out(:,:,c)==token) = media(c);
end

end

