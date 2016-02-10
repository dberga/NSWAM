function [iFactor] = Zaoping_Li(dades, struct,wav)

factor_normal=struct.zli.normal_input;
n_iter=struct.zli.niter;

	% normalitzacio
	shift=struct.zli.shift;


	normal_max=max(dades(:));
	normal_min=min(dades(:));

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

	dades=((dades-normal_min)/(normal_max-normal_min))*(factor_normal-shift)+shift;


	% dynamical system
% 	dades=squeeze(dades);

	[gx_final,gy_final] = Qmodelinductiond_v0_2(dades,struct,wav);

% 	if struct.compute.dynamic~=1
		% mean over the iteration
% 		iFactor=mean(gx_final(:,:,:,1:n_iter),4);
% 	else
		% take gx directly
		iFactor=gx_final;
% 	end




% function [iFactor] = Zaoping_Li(dades, factor_normal, prec,niter,de,di,genpar,scale)
% 
% 	% Normalitzacio
% 	shift=1;
% 	normal=max(max(abs(dades)));
% 	if normal~=0
% 		dades=dades/normal*(factor_normal-shift)+shift;
% 	end
% 	
% 	[gx_final,gy_final] = Qmodelinduction_v3_6(dades,prec,niter,2,'mirror',de,di,genpar,scale);
% 	
% 	iFactor=mean(gx_final(:,:,:,1:niter),4);
% 

end