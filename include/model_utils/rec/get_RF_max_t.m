

 
 



function [RFmax, RFresidual] = get_RF_max_t(c1_RF,c1_residual,c1_Ls,c2_RF,c2_residual,c2_Ls,c3_RF,c3_residual,c3_Ls,struct,s)

	
	
	%initialize	
	RFmax = zeros(size(c1_RF{s}{1},1),size(c1_RF{s}{1},2));
    RFresidual = zeros(size(c1_RF{s}{1},1),size(c1_RF{s}{1},2));
	
	%look for max for each frame and scale
	for o=1:3
        newmax_c1 = c1_RF{s}{o}; 
		for x=1:size(c1_RF{s}{o},1)
		    for y=1:size(c1_RF{s}{o},2)
			if newmax_c1(x,y) > RFmax(x,y)
				RFmax(x,y) = newmax_c1(x,y);
				RFresidual(x,y) = c1_residual{s}(x,y);
			end
		    end
        end
        newmax_c2 = c2_RF{s}{o}; 
		for x=1:size(c2_RF{s}{o},1)
		    for y=1:size(c2_RF{s}{o},2)
			if newmax_c2(x,y) > RFmax(x,y)
				RFmax(x,y) = newmax_c2(x,y);
				RFresidual(x,y) = c2_residual{s}(x,y);
			end
		    end
        end
        newmax_c3 = c3_RF{s}{o}; 
		for x=1:size(c3_RF{s}{o},1)
		    for y=1:size(c3_RF{s}{o},2)
			if newmax_c3(x,y) > RFmax(x,y)
				RFmax(x,y) = newmax_c3(x,y);
				RFresidual(x,y) = c3_residual{s}(x,y);
			end
		    end
		end
	end

end
