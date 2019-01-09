function [ iFactor ] = apply_topdown_swam( iFactor, conf_struct, topdown_matrix_multidim )

if  conf_struct.search_params.topdown == 1
    %topdown_matrix_multidim(isnan(topdown_matrix_multidim))=0;
    for ff=1:conf_struct.zli_params.n_membr
        for iter=1:conf_struct.zli_params.n_iter
            for s=1:conf_struct.wave_params.n_scales-1
                for o=1:conf_struct.wave_params.n_orient
                    %invert inhibition and multiply
                    topdown_on=(conf_struct.search_params.multiplier-topdown_matrix_multidim(:,:,s,o,1));
                    topdown_off=(conf_struct.search_params.multiplier-topdown_matrix_multidim(:,:,s,o,2));
                    iFactor_on= iFactor{ff}{iter}{s}(:,:,o) .* topdown_on; %on
                    iFactor_off= iFactor{ff}{iter}{s}(:,:,o) .* topdown_off; %off
                    iFactor{ff}{iter}{s}(:,:,o)=iFactor_on+iFactor_off;
                    
                end
            end
        end
    end
end

end

