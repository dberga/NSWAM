function [theta]=angle_orient(orient,transf)



% switch(transf)
% 	case('wav')
% 		thetas=[0 pi/4 pi/2];
% 	case('a_trous')
% 		thetas=[0 pi/4 pi/2 3*pi/4];
% 	case('a_trous_contrast')
% 		thetas=[0 pi/4 pi/2 3*pi/4];
% 	case('gabor_HMAX')
% 		thetas=[0 pi/4 pi/2 3*pi/4];
% end


%  S'han de posar en la direccio perpendicular, ja que una cosa es la dir 
% de variacio i l'altra la del marge

switch(transf)
	case('wav')
		thetas=[pi/2 -pi/4 0];
	case('a_trous')
		thetas=[pi/2 -pi/4 0 pi/4];
% 		thetas=[pi/2 -pi/4 0];
	case('a_trous_contrast')
		thetas=[pi/2 -pi/4 0 pi/4];
% 		thetas=[pi/2 -pi/4 0];
	case('gabor_HMAX')
		thetas=[pi/2 -pi/4 0 pi/4];
end


theta=thetas(orient);

end

