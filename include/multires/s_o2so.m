function [ RF_so] = s_o2so( RF_s_o, n_scales, n_orient )
    
    RF_so = cell(n_scales,n_orient,1);
    
    for s=1:n_scales-1
       for o=1:n_orient
           RF_so{s}{o} = RF_s_o{s}(:,:,o);
       end
       
    end
    

end

