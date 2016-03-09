
        
function [smap] = RF_to_smap(RF_t_s_o_c,residual_s_c,Ls_s_c,struct)

    %0. compute temporal mean (RF_t_s_o_c -> RF_s_o_c)
        
    
    %hacer media temporal
    RF_s_o_c = tmatrix_to_matrix(RF_t_s_o_c,struct);
    %residual_s_c = tmatrix_to_matrix_norient(residual_t_s_c,struct);
    %Ls_s_c = tmatrix_to_matrix_norient(Ls_t_s_c,struct);
    
    smap = RF_to_smap_t(RF_s_o_c,residual_s_c,Ls_s_c,struct);
        %1. compute ecsf (RF_s_o_c -> RF_s_o_c)
        %2. compute pmax2 (RF_s_o_c -> RF_s)
        %3. compute IDWT (RF_s -> RF)
        %4. compute Z (RF -> RF)
    

end








