function image_padded = add_padding(image)
% Pads image so that dimensions are powers of 2.
%
% outputs:
%   image_padded: padded image.
%
% inputs:
%   image: input image.

height = size(image,1);
width = size(image,2);

% pad image when dimensions are not powers of 2/equal to each other:
nearest_pow = 2^ceil(log2(max(width,height))); if nearest_pow <= max(height,width), nearest_pow=2^ceil(log2(max(width,height))+1); end
image_padded = zeros(nearest_pow);
image_padded(1:height,1:width) = image;
image_padding = nearest_pow - [height width];
% % 
% % % pad right extreme:
% % if image_padding(2) < width
% %     image_padded(1:height,(width + 1):end) = fliplr(image(:,(end-image_padding(2)):(end - 1)));
% % 
% % % deal with padding when >= image
% % else
% %     extra_padding = image_padding(2) - width + 2;
% %     image_extra_padded = fliplr([fliplr(image_padded(:,2:extra_padding)), image_padded(:,1:(width-1))]);
% %     image_padded(:,(width+1):end) = image_extra_padded;
% % end
% % 
% % % pad bottom extreme:
% % if image_padding(1) < height
% %     image_padded((height+1):end,:) = flipud(image_padded((height-image_padding(1)):(height - 1),:));
% % 
% % % deal with padding when >= image
% % else
% %     extra_padding = image_padding(1) - height + 2;
% %     image_extra_padded = flipud([flipud(image_padded(2:extra_padding,:)), image_padded(1:(height-1),:)]);
% %     image_padded((height+1):end,:) = image_extra_padded;
% % end

padding_horizontal=floor((nearest_pow-width)/2); 
padding_vertical=floor((nearest_pow-height)/2); 
image_padded_alt=padarray(image,[padding_vertical,padding_horizontal],'symmetric','both');
image_padded(1:size(image_padded_alt,1),1:size(image_padded_alt,2))=image_padded_alt;

end

%%image_padded_alt=padarray(image,[(nearest_pow-height)*0.5,(nearest_pow-width)*0.5],'symmetric','both');