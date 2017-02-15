function [ multidim , residual] = multires_decomp2multidim( w,c, n_scales, n_orient )
    

    residual = c;
    
    for s=1:n_scales-1
       for o=1:n_orient
           multidim(:,:,s,o) = w{s}(:,:,o);
       end
      
    end
    
     %curv{n_scales}{1} = c{n_scales-1};
     
     
end

