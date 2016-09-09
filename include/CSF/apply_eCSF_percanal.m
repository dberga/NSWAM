function [RF_s_o_c] = apply_eCSF_percanal(RF_s_o_c, struct)

  channels = {'chromatic', 'chromatic2' ,'intensity'};
                
    
    
        for s=1:struct.wave_params.n_scales-1
            for o=1:struct.wave_params.n_orient
                for c=1:3
                    RF_s_o_c{s}{o}(:,:,c) = generate_csf_givenparams(RF_s_o_c{s}{o}(:,:,c), s,struct.csf_params.nu_0,channels{c},struct.csf_params.params_intensity,struct.csf_params.params_chromatic);
                end
            end
        end
                    
    

end