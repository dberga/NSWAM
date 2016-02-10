function [iFactor] = Zaoping_Li(dades, struct,scale)

factor_normal=struct.zli.normal_input;

	% normalitzacio
	shift=struct.zli.shift;
	normal=max(abs(dades(:)));
	if normal~=0
		dades=(dades/normal)*(factor_normal-shift)+shift;
	end
	
	% dynamical system
% 	dades=squeeze(dades);
	[gx_final,gy_final] = Qmodelinductiond_v0_0(dades,struct,scale);
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