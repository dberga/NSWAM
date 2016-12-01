          
function [RF_c] = get_opp2rgb(loaded_struct,RF_c)
            if loaded_struct.color_params.orgb_flag == 1  
                RF_c = get_the_ostimulus(RF_c,loaded_struct.color_params.gamma,loaded_struct.color_params.srgb_flag);
            end 
end
            

