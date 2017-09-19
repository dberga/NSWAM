

 
 
 
%RF dimensions: 
%RF{temp}{scale}{orient}(x,y)

%w dimensions:
%w{scale}(x,y,orient)

%c dimensions:
%w{scale}(x,y)


function [img_out] = RF_to_rec_channel(RF,residual,Ls, struct)

n_scales =  struct.wave_params.n_scales;
n_membr = struct.zli_params.n_membr;
method = struct.wave_params.multires;

img_out = IDWTdispatcher(RF,n_scales,n_membr,method,residual,Ls);

end

function [img_out] = IDWTdispatcher(RF,n_scales,n_membr,method,residual, Ls)
    

    
    % N.B.: we only perform the inverse wavelet transform of the frames used for computing the
    % mean, and NOT of all the sequence !


    % inverse transform

    % prepare output image
    %img_out=zeros(size(RF{1}{1}{1},1),size(RF{1}{1}{1},2),fin_scale-ini_scale+1);
    RFsize = [size(RF{1}{1}{1},1) size(RF{1}{1}{1},2)];
    img_out=zeros(RFsize(1),RFsize(2), n_membr);
    %img_out=zeros(size(img_in));
    
    w = cell(n_scales-1);
    c = residual;
    
    
    switch (method)
       case 'curv'
            for ff=1:n_membr
                for s=1:n_scales
                    n_orient=size(RF{ff}{s},2);
                    for o=1:n_orient
                        c{n_scales-s+1}{o}=RF{ff}{s}{o};
                    end
                end
                img_out(:,:,ff) = ifdct_wrapping(c,1,size(img_in,1),size(img_in,2));
            end
       case 'a_trous'
            for ff=1:n_membr
               for s=1:n_scales-1
                    for o=1:3
                        w{s}(:,:,o)=RF{ff}{s}{o};
                    end
                end
              c{n_scales-1}=RF{ff}{n_scales}{1};
                img_out(:,:,ff) = Ia_trous(w,c);
            end
        case 'a_trous4'
            for ff=1:n_membr
               for s=1:n_scales-1
                    for o=1:4
                        w{s}(:,:,o)=RF{ff}{s}{o};
                    end
                end
              c{n_scales-1}=RF{ff}{n_scales}{1};
                img_out(:,:,ff) = Ia_trous4(w,c);
            end
       case 'a_trous_contrast'
            for ff=1:n_membr
               for s=1:n_scales-1
                    for o=1:3
                        w{s}(:,:,o)=RF{ff}{s}{o};
                    end
                end
              c{n_scales-1}=RF{ff}{n_scales}{1};
                img_out(:,:,ff) = Ia_trous_contrast(w,c);
            end
       case 'wav'
            for ff=1:n_membr
               for s=1:n_scales-1
                    for o=1:3
                        w{s}(:,:,o)=RF{ff}{s}{o};
                    end
                end
              c{n_scales-1}=RF{ff}{n_scales}{1};
                img_out(:,:,ff) = IDWT(w,c,size(img,2), size(img,1));
            end
       case 'wav_contrast'
            for ff=1:n_membr
               for s=1:n_scales-1
                    for o=1:3
                        w{s}(:,:,o)=RF{ff}{s}{o};
                    end
                end
              c{n_scales-1}=RF{ff}{n_scales}{1};
                img_out(:,:,ff) = IDWT_contrast(w,c,size(img,2), size(img,1));
            end
        case 'gabor'
            img_out=IGaborTransform_XOP(RF,n_scales,Ls);
       case 'gabor_HMAX'
          disp('No valid multiresolution decomposition method for Gabor_HMA ... img_out=img*0;');
            img_out=img*0;
       otherwise
          disp('ERROR: No valid multiresolution decomposition method');
       return;   
    end
end
