function [ w, c] = multires_curv2decomp( curv,residual, n_scales, n_orient )
    
    w = cell(n_scales,n_orient);
    c = residual;
    
    for s=1:n_scales-1
       for o=1:n_orient
           w{s}(:,:,o) = curv{s}{o};
       end
       
    end
   %c{n_scales-1} = curv{n_scales}{1};
    

end

