function [ RFmax_s,residualmax_s, max_s, max_o, max_c, max_x, max_y ] = get_waves_max_t( RF_s_o_c,residual_s_c,n_scales,n_orient,C )
    RFmax_s = cell(n_scales-1,1);
    residualmax_s = cell(n_scales-1,1);
    
    for s=1:n_scales-1
        RFmax = (-Inf).*ones(size(RF_s_o_c{s}{1}(:,:,1)));
        residualmax= (-Inf).*ones(size(residual_s_c{s}(:,:,1)));
        for o=1:n_orient
            for c=1:C
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
                           max_x=x;
                           max_y=y;
                        end
                    end
                end
            end
        end
        RFmax_s{s} = RFmax;
        residualmax_s{s} = residualmax;
    end
end

