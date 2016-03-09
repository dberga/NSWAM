
function [RF_s_c] = tmatrix_to_matrix_norient(RF_t_s_c, struct)

        RF_t_s_o_c = repicate_orient_t(RF_t_s_c, struct);
        
       RF_s_o_c = tmatrix_to_matrix(RF_t_s_o_c,struct);
       
       RF_s_c = erase_orient(RF_s_o_c, struct);
       
        
end
