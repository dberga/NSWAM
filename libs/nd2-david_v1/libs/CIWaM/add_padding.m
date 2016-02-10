function image_padded = add_padding(image)
% Pads image so that dimensions are powers of 2.
%
% outputs:
%   image_padded: padded image.
%
% inputs:
%   image: input image.

[height width] = size(image);

% pad image when dimensions are not powers of 2/equal to each other:
nearest_pow = 2^ceil(log2(max(width,height)));
image_padded = zeros(nearest_pow);
image_padded(1:height,1:width) = image;
image_padding = nearest_pow - [height width];

% pad right extreme:
if image_padding(2) < width
    image_padded(1:height,(width + 1):end) = fliplr(image(:,(end-image_padding(2)):(end - 1)));

% deal with padding when >= image
else
    numImgs = floor(image_padding(2)/width);
    extra_padding = image_padding(2) - numImgs*width + numImgs + 1;
    padding = [];
    for i = 1:numImgs
        if rem(i,2) == 1
            padding = [padding fliplr(image(:,1:(width-1)))];
        else
            padding = [padding image(:,2:width)];
        end
    end
    if rem(i,2) == 1
        padding = [padding image(:,2:extra_padding)];
    else
        padding = [padding fliplr(image(:,end - extra_padding+2:end))];
    end
    image_padded(1:height,(width+1):end) = padding;
end

% pad bottom extreme:
if image_padding(1) < height
    image_padded((height+1):end,:) = flipud(image_padded((height-image_padding(1)):(height - 1),:));

% deal with padding when >= image
else
    numImgs = floor(image_padding(1)/height);
    extra_padding = image_padding(1) - numImgs*height + numImgs + 1;
    padding = [];
    for i = 1:numImgs
        if rem(i,2) == 1
            padding = [padding; flipud(image_padded(1:(height-1),:))];
        else
            padding = [padding; image_padded(2:height,:)];
        end
    end
    if rem(i,2) == 1
        padding = [padding; image_padded(2:extra_padding,:)];
    else
        padding = [padding; flipud(image_padded(end - extra_padding+2:end,:))];
    end
    image_padded((height+1):end,:) = padding;
end

end

