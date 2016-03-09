function [RF_s_o_c] = apply_eCSF_percanal(RF_s_o_c, struct)

  channels = {'chromatic', 'chromatic2' ,'intensity'};
                
    
    
        for s=1:struct.wave.n_scales-1
            for o=1:struct.wave.n_orient
                for c=1:3
                    RF_s_o_c{s}{o}(:,:,c) = generate_csf_givenparams(RF_s_o_c{s}{o}(:,:,c), s,struct.csfparams.nu_0,channels{c},struct.csfparams.params_intensity,struct.csfparams.params_chromatic);
                end
            end
        end
                    
    

end