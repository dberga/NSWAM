function [ im_out ] = padding_square2original( im_in, x_margin,y_margin )


[M,N,C] = size(im_in);
im_out = im_in;

if x_margin > 0
im_out = im_in(:,x_margin:N-x_margin,:);
end

if y_margin > 0
im_out = im_in(y_margin:M-y_margin,:,:);
end



end

