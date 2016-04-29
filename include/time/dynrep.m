function [ timg ] = dynrep( img , n_membr )

    timg=zeros(size(img));
    for ff=1:n_membr
        timg(:,:,:,ff)=img(:,:,:);
    end   

end

