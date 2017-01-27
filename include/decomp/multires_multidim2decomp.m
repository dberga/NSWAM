function [ w, c ] = multires_multidim2decomp( multidim, residual, n_scales, n_orient )
    
    c = residual;
    
    for s=1:n_scales-1
       for o=1:n_orient
           w{s}(:,:,o) = multidim(:,:,s,o);
       end
      
    end
    
end

