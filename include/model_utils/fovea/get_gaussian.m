

 
function [gaussian] = get_gaussian(M,N,sigma, factor)

	gaussian = fspecial('Gaussian',[M N],sigma);
	gaussian = normalize_map(gaussian,factor,0); %doubles go from 0 to 1 (factor = 1, floor_flag = 0)

end
