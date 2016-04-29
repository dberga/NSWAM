

 
 



function [RFmax_s, residualmax_s,Lsmax_s] = get_RF_max_t(RF_s_o_c,residual_s_c,Ls_s_c,struct)

	
	RFmax_s = cell(struct.wave.n_scales,1);
    residualmax_s = cell(struct.wave.n_scales-1,1);
    Lsmax_s = cell(struct.wave.n_scales-1,1);
	
    
	for s=1:struct.wave.n_scales-1
        
        %initialize	
        RFmax = zeros(size(RF_s_o_c{s}{1},1),size(RF_s_o_c{s}{1},2));
        RFresidual = zeros(size(RF_s_o_c{s}{1},1),size(RF_s_o_c{s}{1},2));
        RFls = zeros(size(RF_s_o_c{s}{1},1),size(RF_s_o_c{s}{1},2));
        
        %look for max for each frame and scale
        for o=1:struct.wave.n_orient
            for c=1:3
                values = RF_s_o_c{s}{o}(:,:,c); 
                for x=1:size(RF_s_o_c{s}{o},1)
                    for y=1:size(RF_s_o_c{s}{o},2)
                        if values(x,y) > RFmax(x,y)
                            RFmax(x,y) = values(x,y);
                            RFresidual(x,y) = residual_s_c{s}(x,y,c);
                            RFls(x,y) = Ls_s_c{s}(x,y,c);
                        end
                    end
                end
            end
        end
        RFmax_s{s} = RFmax;
        residualmax_s{s} = RFresidual;
        Lsmax_s{s} = RFls;
    end
    RFmax_s{struct.wave.n_scales} = RF_s_o_c{struct.wave.n_scales};

end
