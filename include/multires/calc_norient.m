function [n_orient] = calc_norient(img,method,n_scales,n_membr)
    switch (method)
       case 'curv'
           for ff=1:n_membr
                c = fdct_wrapping(img(:,:,ff),1,1,n_scales);
                n_orient = zeros(n_scales);
                for s=1:n_scales
                    n_orient(s)=size(c{s},2);
                end
           end
       case 'a_trous'
           n_orient = 3;
       case 'a_trous_contrast'
           n_orient = 3;
       case 'wav'
           n_orient = 3;
       case 'wav_contrast'
           n_orient = 3;
       case 'a_trous4'
           n_orient = 4;
       case 'gabor'
           n_orient = 4;
       case 'gabor_HMAX'
           n_orient = 4;
        otherwise 
            n_orient = 3;
       
    end
       
end
