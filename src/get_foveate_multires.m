function [ curvs, residuals ] = get_foveate_multires( curvs_aux,residuals_aux,conf_struct )

    for c=1:numel(curvs_aux)
        for s=1:length(curvs_aux{c})%conf_struct.wave_params.n_scales-1
            for o=1:conf_struct.wave_params.n_orient
                curvs{c}{s}(:,:,o)=get_foveate(curvs_aux{c}{s}(:,:,o),conf_struct,1);
            end
            residuals{c}{s}=get_foveate(residuals_aux{c}{s},conf_struct,1);
        end
    end
    
end

