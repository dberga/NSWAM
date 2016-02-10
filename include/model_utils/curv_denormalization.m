function [dades,normal_max,normal_min] = curv_denormalization(dades, struct,normal_max,normal_min)

factor_normal=struct.zli.normal_input;

	% normalitzacio
	shift=struct.zli.shift;

	ncells=size(dades,1);

	for i=1:ncells
		% normalitzacio previa
%  		dades{i}=((dades{i}-normal_min)/(normal_max-normal_min))*(factor_n
%  		ormal-shift)+shift;

% 		dades{i}=(dades{i}-shift).*(normal_max-normal_min)./(factor_normal-shift)+normal_min;
 		dades{i}=dades{i}*(normal_max-normal_min)+normal_min;
	end


end