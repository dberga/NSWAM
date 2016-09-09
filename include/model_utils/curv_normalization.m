function [dades,normal_max,normal_min] = curv_normalization(dades, struct)

factor_normal=struct.zli_params.normal_input;
type=struct.zli_params.normal_type;

	% normalitzacio
	shift=struct.zli_params.shift;

	ncells=size(dades,1);
	n_scales=size(dades{1},3);
	
switch type
	case ('all')
		% For ALL the dataset
		normal_max_v=zeros(ncells,1);
		normal_min_v=zeros(ncells,1);
		
		for i=1:ncells
			normal_max_v(i)=max(dades{i}(:),[],1);
			normal_min_v(i)=min(dades{i}(:),[],1);
		end
		
		normal_max=max(normal_max_v(:),[],1);
		normal_min=min(normal_min_v(:),[],1);
		
		if normal_max==normal_min
			dades{i}=1;
		else
			
			for i=1:ncells
				dades{i}=((dades{i}-normal_min)/(normal_max-normal_min))*(factor_normal-shift)+shift;
			end
		end
			% -------------------------------
	case ('scale')
		% For every scale
		normal_max_v=zeros(n_scales,ncells);
		normal_min_v=zeros(n_scales,ncells);
		for s=1:n_scales
			for i=1:ncells
				kk=dades{i}(:,:,s,:);
				normal_max_v(s,i)=max(kk(:),[],1);
				normal_min_v(s,i)=min(kk(:),[],1);
			end
		end
		normal_max=max(normal_max_v,[],2);
		normal_min=min(normal_min_v,[],2);
		
		for s=1:n_scales
			if normal_max(s)==normal_min(s)
				for i=1:ncells
					dades{i}(:,:,s,:)=1.02; % El minim segons Li1998
				end
			else
				for i=1:ncells
					dades{i}(:,:,s,:)=((dades{i}(:,:,s,:)-normal_min(s))/(normal_max(s)-normal_min(s)))*(factor_normal-shift)+shift;
				end
			end
		end
			% -------------------------------

	case ('absolute')
		normal_min=struct.zli_params.normal_min_absolute; 
		normal_max=struct.zli_params.normal_max_absolute; 
			for i=1:ncells
				dades{i}=((dades{i}-normal_min)/(normal_max-normal_min))*(factor_normal-shift)+shift;
			end
			
	% For every membrane time
% 	normal_max=max(max(abs(dades),[],1),[],2);
% 	normal_min=min(min(abs(dades),[],1),[],2);
% 	
% 	for ff=1:n_iter
% 		if(normal_max(ff)==normal_min(ff))
% 			dades(:,:,ff)=ones(size(dades(:,:,ff)))*(factor_normal+shift)*0.5;
% 		else
% 			if normal_max~=0
% 				dades(:,:,ff)=((dades(:,:,ff)-normal_min(ff))/(normal_max(ff)-normal_min(ff)))*(factor_normal-shift)+shift;
% 			end
% 		end
% 	end
	% -------------------------------

end


for i=1:ncells
	dades{i}(dades{i}==shift)=0; % Per posar a zero el que era zero inicialment (Li1998)
end
	
end