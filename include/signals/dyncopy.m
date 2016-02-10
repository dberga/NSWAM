function [ timg ] = dyncopy( img , n_membr )

    timg=zeros(size(img));
    for ff=1:n_membr
        timg(:,:,:,ff)=img(:,:,:,ff);
    end   

end

