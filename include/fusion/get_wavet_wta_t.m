function [ RFmax, residualmax,max_s,max_o,max_c, max_x, max_y ] = get_wavet_wta_t( RF_s_o_c,residual_s_c, n_scales, n_orient, C )

    RFmax = (-Inf).*ones(size(RF_s_o_c{1}{1}(:,:,1)));
    residualmax = (-Inf).*ones(size(residual_s_c{1}(:,:,1)));
    maxval=-Inf;
    
	for s=1:n_scales-1
        for o=1:n_orient
            for c=1:C
                values = RF_s_o_c{s}{o}(:,:,c); 
                values_residual = residual_s_c{s}(:,:,c); 
                for y=1:size(RF_s_o_c{s}{o},1)
                    for x=1:size(RF_s_o_c{s}{o},2)
                        if values(y,x) >= RFmax(y,x)
                            %RFmax(y,x) = values(y,x);
                            %residualmax(y,x) = values_residual(y,x);
                        end
                        if values(y,x) >= maxval
                           maxval=values(y,x);
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
    end
    
    RFmax=RF_s_o_c{max_s}{max_o}(:,:,max_c);
    residualmax=residual_s_c{max_s}(:,:,max_c);
    
end

