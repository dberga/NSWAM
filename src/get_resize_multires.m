function [ curvs, residuals ] = get_resize_multires( w, cw, conf_struct )

    
    n_orient=conf_struct.wave_params.n_orient;
    n_scales=conf_struct.wave_params.n_scales;
    
    curvs=cell(length(w));
    residuals=cell(length(cw));
    for c=1:length(w)
        for s=1:n_scales-1
            for o=1:n_orient
                curvs{c}{s}(:,:,o)=get_resize(w{c}{s}(:,:,o),conf_struct);
            end
            residuals{c}{s}=get_resize(cw{c}{s},conf_struct);
        end
        
    end

end

