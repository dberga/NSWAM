function [ RFmax_c,residualmax_c, max_s, max_o, max_c ] = get_wavec_max_t( RF_s_o_c, residual_s_c, n_scales, n_orient, C )

    RFmax_c = zeros(size(RF_s_o_c{1}{1}));
    residualmax_c = zeros(size(residual_s_c{1}));
    
    
    for c=1:C
        RFmax = zeros(size(RF_s_o_c{1}{1}(:,:,1)));
        residualmax = zeros(size(residual_s_c{1}(:,:,1)));
        for s=1:n_scales-1
            for o=1:n_orient
                values = RF_s_o_c{s}{o}(:,:,c); 
                values_residual = residual_s_c{s}(:,:,c); 
                for y=1:size(RF_s_o_c{s}{o},1)
                    for x=1:size(RF_s_o_c{s}{o},2)
                        if values(y,x) > RFmax(y,x)
                            RFmax(y,x) = values(y,x);
                            residualmax(y,x) = values_residual(y,x);
                            max_s=s;
                            max_o=o;
                            max_c=c;
                        end
                    end
                end
            end
        end
        RFmax_c(:,:,c) = RFmax;
        residualmax_c(:,:,c) = residualmax;
    end
    
end

