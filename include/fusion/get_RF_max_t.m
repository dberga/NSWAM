

 



function [RFmax_s, residualmax_s, max_s, max_o, max_c, max_x, max_y] = get_RF_max_t(RF_s_o_c,residual_s_c,n_channels,n_scales,n_orient)

	
	RFmax_s = cell(n_scales-1,1);
    residualmax_s = cell(n_scales-1,1);
    
	
    
	for s=1:n_scales-1
        
        %initialize	
        RFmax = (-Inf).*ones(size(RF_s_o_c{s}{1},1),size(RF_s_o_c{s}{1},2));
        RFresidual = (-Inf).*ones(size(RF_s_o_c{s}{1},1),size(RF_s_o_c{s}{1},2));
        
        %look for max for each frame and scale
        for o=1:n_orient
            for c=1:n_channels
                values = RF_s_o_c{s}{o}(:,:,c); 
                for y=1:size(RF_s_o_c{s}{o},1)
                    for x=1:size(RF_s_o_c{s}{o},2)
                        if values(y,x) >= RFmax(y,x)
                            RFmax(y,x) = values(y,x);
                            RFresidual(y,x) = residual_s_c{s}(y,x,c);
                            
                            max_s = s;
                            max_o = o;
                            max_c = c;
                            max_x = x;
                            max_y = y;
                        end
                    end
                end
            end
        end
        RFmax_s{s} = RFmax;
        residualmax_s{s} = RFresidual;
    end
    %RFmax_s{n_scales} = RF_s_o_c{n_scales};

end
