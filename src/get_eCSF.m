function [RF_s_o_c] = get_eCSF(loaded_struct,RF_s_o_c)
            if strcmp(loaded_struct.fusion_params.output_from_csf,'eCSF') == 1
                [RF_s_o_c] = apply_eCSF_percanal(RF_s_o_c, loaded_struct);
            end
            
end


  