

 



function [RFmax_s, residualmax_s, max_s, max_o, max_c, max_x, max_y] = get_RF_max_t(RF_s_o_c,residual_s_c,struct)

	
	RFmax_s = cell(struct.wave_params.n_scales,1);
    residualmax_s = cell(struct.wave_params.n_scales-1,1);
    
	
    
	for s=1:struct.wave_params.n_scales-1
        
        %initialize	
        RFmax = zeros(size(RF_s_o_c{s}{1},1),size(RF_s_o_c{s}{1},2));
        RFresidual = zeros(size(RF_s_o_c{s}{1},1),size(RF_s_o_c{s}{1},2));
        
        %look for max for each frame and scale
        for o=1:struct.wave_params.n_orient
            for c=1:struct.color_params.nchannels
                values = RF_s_o_c{s}{o}(:,:,c); 
                for y=1:size(RF_s_o_c{s}{o},1)
                    for x=1:size(RF_s_o_c{s}{o},2)
                        if values(y,x) > RFmax(y,x)
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
    RFmax_s{struct.wave_params.n_scales} = RF_s_o_c{struct.wave_params.n_scales};

end
