function [ RF_s_o] = so2s_o( RF_so, n_scales, n_orient )
    
    RF_s_o = cell(n_scales-1,1);
    
    for s=1:n_scales-1
       for o=1:n_orient
           RF_s_o{s}(:,:,o) = RF_so{s}{o};
       end
       
    end
    

end
