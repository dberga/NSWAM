function [ curv, residual] = multires_decomp2curv( w,c, n_scales, n_orient )
    
    curv = cell(n_scales-1,n_orient);
    residual = c;
    
    for s=1:n_scales-1
       for o=1:n_orient
           curv{s}{o} = w{s}(:,:,o);
       end
      
    end
    
     %curv{n_scales}{1} = c{n_scales-1};
     
end

