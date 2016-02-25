function [ x, y] = get_coord_props_inv( e,azimuth,xcenter,ycenter,M,N,max_M,max_N, vAngle)

		
		
		%%to positive angle values
	                theta = azimuth*(pi/180);
		%%rho
		max_r = sqrt(M^2 + N^2);
		rho = (e*max_r)/vAngle;
		
		%relocalitzar centre de input image a input image gran
		xcenter2 = round((xcenter/N)*max_N);
		ycenter2 = round((ycenter/M)*max_M);		


		%potser malament, utilitzar xcenter2,ycenter2. sino els de X i Y
		%[theta_center,rho_center] = cart2pol(xcenter,ycenter); 
		%theta = theta_center - theta;
		%rho = rho_center - rho;

		%%polar to cartesian
			%x_rel = rho*cos(theta);
			%y_rel = rho*sin(theta);
		[x_rel,y_rel] = pol2cart(theta,rho);


		
		

		x = x_rel+(max_N/2);
		y = y_rel+(max_M/2);


end

