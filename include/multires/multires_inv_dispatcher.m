


function [img_out] = multires_inv_dispatcher(w,c,method,n_scales,n_orient)
    

    
    % N.B.: we only perform the inverse wavelet transform of the frames used for computing the
    % mean, and NOT of all the sequence !



    % prepare output image
    img_size = [size(w{1}(:,:,1),1) size(w{1}(:,:,1),2)];
    img_out=zeros(img_size(1),img_size(2));
    %img_out=zeros(size(img_in));
    w=w(~cellfun('isempty',w));
    c=c(~cellfun('isempty',c));
    
    %in case of reading residual with different dims (old conf)
    for s=1:n_scales
        if img_size(1) ~= size(c{s},1) || img_size(2) ~= size(c{s},2)
                c{s}=imresize(c{s},img_size);
        end
    end

    
    switch (method)
       case 'curv'
                for s=1:n_scales
                    for o=1:n_orient
                        c{n_scales-s+1}{o}=w{s}(:,:,o);
                    end
                end
                img_out(:,:) = ifdct_wrapping(c,1,img_size(1),img_size(2));

       case 'a_trous'
               img_out(:,:) = Ia_trous(w,c);
                
       case 'a_trous4'
               img_out(:,:) = Ia_trous4(w,c);
               
       case 'a_trous_contrast'
               img_out(:,:) = Ia_trous_contrast(w,c);
                

       case 'wav'
               img_out(:,:) = IDWT(w,c,img_size(2), img_size(1));
                
       case 'wav_contrast'
               img_out(:,:) = IDWT_contrast(w,c,img_size(2), img_size(1));
                
            
        case 'gabor'
            img_out=IGaborTransform_XOP(w,n_scales,c);
       case 'gabor_HMAX'
          disp('No valid multiresolution decomposition method for Gabor_HMA ... img_out=img*0;');
            img_out=img*0;
       otherwise
          disp('ERROR: No valid multiresolution decomposition method');
       return;   
    end
end


