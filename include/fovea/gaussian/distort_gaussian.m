function [ im_out ] = distort_gaussian( im_in, gaussian)


    if nargin < 2
        M=size(im_in,1);
        N=size(im_in,2);
        %SQ=sqrt(size(im_in,1)*size(im_in,2));
        SQ=sqrt(size(im_in,1)*size(im_in,1)+size(im_in,2)*size(im_in,2));
        factor=1;
        gaussian = get_gaussian(M,N,100, factor,round(N/2),round(M/2));
    end
    
    %im_out = im_in;
    for c=1:size(im_in,3)
        im_out(:,:,c) = distort_gaussian_channel(im_in(:,:,c),gaussian);
    end
    

end


function [channel_out] = distort_gaussian_channel(im_in, gaussian)

	channel_out = im2double(im_in)+gaussian;
    
    
end
