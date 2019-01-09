function [ iFactor ] = apply_topdown_swam( iFactor, conf_struct, ior_matrix_multidim )

if  conf_struct.gaze_params.ior == 1 && conf_struct.gaze_params.ior_multidim_set == 1
    ior_matrix_multidim(isnan(ior_matrix_multidim))=0;
    for ff=1:conf_struct.zli_params.n_membr
        for iter=1:conf_struct.zli_params.n_iter
            for s=1:conf_struct.wave_params.n_scales-1
                for o=1:conf_struct.wave_params.n_orient
                    %invert inhibition and multiply
                    topdown_on=(4-ior_matrix_multidim(:,:,s,o,1));
                    topdown_off=(4-ior_matrix_multidim(:,:,s,o,2));
                    iFactor_on= iFactor{ff}{iter}{s}(:,:,o) .* topdown_on; %on
                    iFactor_off= iFactor{ff}{iter}{s}(:,:,o) .* topdown_off; %off
                    iFactor{ff}{iter}{s}(:,:,o)=iFactor_on+iFactor_off;
                    
                end
            end
        end
    end
end

end

