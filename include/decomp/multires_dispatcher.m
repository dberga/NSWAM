function [w, c] = multires_dispatcher(img, method,n_scales,n_orient)

    w = cell(n_scales-1,1); %output {s}(:,:,o)
    c = cell(n_scales-1,1); %residual {s}(:,:)
    
    %w = cell(n_scales,1); %output {s}(:,:,o)
    %c = cell(n_scales,1); %residual {s}(:,:)
    
    % different wavelet decompositions		
    switch (method)
       case 'curv'
            c = fdct_wrapping(img(:,:),1,1,n_scales);
            for s=1:n_scales
                for o=1:n_orient
                    w{n_scales-s+1}(:,:,o)=c{s}{o};
                end
            end
       case 'a_trous'
              [w, c] = a_trous(img(:,:), n_scales-1);
               
       case 'a_trous_contrast'
              [w, c] = a_trous_contrast(img(:,:), n_scales-1);
            
       case 'wav'
                [w, c] = DWT(img(:,:), n_scales-1);
                
       case 'wav_contrast'
            
                [w, c] = DWT_contrast(img(:,:), n_scales-1);
            
       case 'gabor'
                [w,c]=GaborTransform_XOP(img(:,:),n_scales);
             
       case 'gabor_HMAX'
    
                [w,n_scales]=Gabor_decomposition(img);
                disp(['gabor_HMAX n_scales:' int2str(n_scales)]);
    
       otherwise
          devlog('ERROR: No valid multiresolution decomposition method',4);
          return;
    end
    
    
    % induce artificila activity to a given neuron population (Rossi and Paradiso, 1999, Figure 2.3)

    

end