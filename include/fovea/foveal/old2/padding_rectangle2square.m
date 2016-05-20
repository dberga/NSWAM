function [ im_out ] = padding_rectangle2square( im_in, x_margin, y_margin , token)
%also output indexes?

if nargin < 4
    token = -inf;
end

[M,N,C] = size(im_in);
im_out = im_in;


if x_margin > 0
    im_out(:,x_margin:N+x_margin-1,:) = im_out(:,1:N,:);
    im_out(:,1:x_margin,:) = token;
    im_out(:,N+x_margin:N+x_margin+x_margin,:) = token;
end

if y_margin > 0
    im_out(y_margin:M+y_margin-1,:,:) = im_out(1:M,:,:);
    im_out(1:y_margin,:,:) = token;
    im_out(M+y_margin:M+y_margin+y_margin,:,:) = token;
end

end

