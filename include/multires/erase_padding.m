function [ image ] = erase_padding( image_padded , orig_size )


height = orig_size(1);
width = orig_size(2);

% pad image when dimensions are not powers of 2/equal to each other:
nearest_pow = 2^ceil(log2(max(width,height))); if nearest_pow <= max(height,width), nearest_pow=2^ceil(log2(max(width,height))+1); end

padding_horizontal=floor((nearest_pow-width)/2);
padding_vertical=floor((nearest_pow-height)/2); 
image=image_padded(padding_vertical:padding_vertical+height-1,padding_horizontal:padding_horizontal+width-1);

end

