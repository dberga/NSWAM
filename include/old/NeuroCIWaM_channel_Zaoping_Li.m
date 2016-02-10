function [img_out] = NeuroCIWaM_channel_Zaoping_Li(img_in, niter, prec,de,di,genpar,multires,n_scales,normal_input,normal_output,ON_OFF,nu_0,channel,parallel)
%
%	img_in: monocromatic input image(1 channel)
%	niter: number of iterations (tipically around 20)
%	prec: precision (tipically 0.01-0.1)

%niter=20;
%prec=0.1;

ini_scale=3; % scale=1 es el pla de mes baixa frequencia. A partir de scale=2 van de alta frequencia a baixa
fin_scale=n_scales;


% En cas que la imatge sigui tota zero
% if max(max(img_in))==min(min(img_in)) && max(max(img_in))==0
% En cas que la imatge sigui tota uniforme
if max(max(img_in))==min(min(img_in))
   img_out=img_in;
   return;
end


% factor_normal=4.0;


img=double(img_in);
%im=img(size(img,1)/2,:,1);	% fila central
%figure,plot(im)

switch (multires)
   case 'curv'
      curv = fdct_wrapping(img,1,1,n_scales);
   case 'a_trous'
      [w c] = a_trous(img, n_scales-1);
      curv{1}{1}=c{n_scales-1};
      for s=2:n_scales
         for o=1:3
            curv{s}{o}=w{s-1}(:,:,o);
         end
      end
   case 'wav'
      [w c] = DWT(img, n_scales-1);
      curv{1}{1}=c{n_scales-1};
      for s=2:n_scales
         for o=1:3
            curv{s}{o}=w{s-1}(:,:,o);
         end
      end
   case 'wav_contrast'
      [w c] = DWT_contrast(img, n_scales-1);
      curv{1}{1}=c{n_scales-1};
      for s=2:n_scales
         for o=1:3
            curv{s}{o}=w{s-1}(:,:,o);
         end
      end
   case 'gabor'
		[curv,Ls]=GaborTransform_XOP(img,n_scales);
   otherwise
      disp('ERROR: No valid multiresolution decomposition method');
      return;
end

% % Normalitzacio
% for s=1:n_scales
%    n_orient=size(curv{s},2);
% 	for o=1:n_orient
%       normal{s}{o}=max(max(abs(curv{s}{o})))/factor_normal;
% 		if normal{s}{o}~=0
% 	      curv{s}{o}=curv{s}{o}/normal{s}{o};
% 		end
% 		mean_orig{s}{o}=mean(mean(curv{s}{o},2),1);
%    end
% end

% mean_orig=mean(mean(curv{1}{1},2),1)

curv_final=curv;
iFactor=curv_final;


if(parallel==1)
   p={'/home/xotazu/neuro/olivier/ZLi_model_for_induction_minimal_implementation_31_1_2011'};
   jm=findResource('scheduler','type','jobmanager','Name','otazu','LookupURL','localhost');
   get(jm);
   job = createJob(jm);
   set(job,'FileDependencies',p)
	set(job,'PathDependencies',p)
	get(job)
end



for scale=ini_scale:fin_scale
	n_orient=size(curv{scale},2);
	disp(['scale: ' int2str(scale) ', n_orient: ' int2str(n_orient)])
   
   param.curv=curv{scale};
   param.niter=niter;
   param.prec=prec;
   param.de=de(scale);
   param.di=di(scale);
%   param.multires=multires;
	param.normal_input=normal_input;
	param.ON_OFF=ON_OFF;
	param.scale=scale;
	param.genpar=genpar;
	
   if(parallel==1)
%   	t=createTask(job, @NeuroCIWaM_channel_Zaoping_Li_orient, 2, {param});
   	t=createTask(job, @NeuroCIWaM_channel_Zaoping_Li_orient, 1, {param});
   else
      curv_final{scale}=NeuroCIWaM_channel_Zaoping_Li_orient(param);

		
		%      [curv_final{scale}, iFactor{scale}]=NeuroCIWaM_channel_Zaoping_Li_orient(param);

%      curv_final{scale}=curv{scale};

		%        for i=1:n_orient
%          figure,imagesc([iFactor{scale}{i} curv{scale}{i}]);colormap(gray);
%        end
%         figure,imagesc([iFactor{scale}{1} curv{scale}{1}]);colormap(gray);
    end

		
	
end

if(parallel==1)
   submit(job)
   get(job,'Tasks')
	  

   waitForState(job, 'finished');
   
	for i=ini_scale:n_scales
      job.Tasks(scale-ini_scale+1).ErrorMessage
	end
   
   out = getAllOutputArguments(job);
   
%   size(out)
%   size(curv_final)

   for scale=ini_scale:n_scales
   	n_orient=size(curv{scale},2);
      for orient=1:n_orient
         curv_final{scale}{orient}=out{scale-ini_scale+1}{orient}(1);
      end
   end

	destroy(job);
end

% % Compensacio pel fet d'estar el output entre 0 i 1
% 	for scale=ini_scale:n_scales
% 		n_orient=size(curv{scale},2);
% 		for orient=1:n_orient
% 			curv_final{scale}{orient}=curv_final{scale}{orient}*factor_normal;
% 		end
% 	end



%img_out = ifdct_wrapping(curv_final,1);
% if strcmp(channel,'intensity')
%    curv_final{1}{1}=curv{1}{1};
% %    for scale=1:n_scales
% %       n_orient=size(curv{scale},2);
% %       for i=1:n_orient
% % %         curv_final{scale}{i}=curv_final{scale}{i}*generate_csf(0.5,scale-1,nu_0,channel);
% %       curv_final{scale}{i}=curv_final{scale}{i}*4;
% %       end
% % 	end
% end


% % Des-Normalitzacio
% for s=1:n_scales
%    n_orient=size(curv{s},2);
% 	for o=1:n_orient
%       curv_final{s}{o}=curv_final{s}{o}*normal{s}{o};
% 		mean_fin{s}{o}=mean(mean(curv_final{s}{o},2),1);
% 	end
%end

% %Energies
% for s=1:n_scales
%    n_orient=size(curv{s},2);
% 	for o=1:n_orient
% 		if mean_fin{s}{o}~=0
% 			curv_final{s}{o}=curv_final{s}{o}*mean_orig{s}{o}/mean_fin{s}{o};
% 		end
% 	end
% end


%mean_fin=mean(mean(curv_final{1}{1},2),1)
%curv_final{1}{1}=curv_final{1}{1}*mean_orig/mean_fin;

%curv_final=curv;

% e-CSF

for scale=ini_scale:n_scales
	n_orient=size(curv{scale},2);
   for i=1:n_orient
%      curv_final{scale}{i}=curv_final{scale}{i}*generate_csf(0.5,scale-1,nu_0,channel);
      curv_final{scale}{i}=curv_final{scale}{i}*normal_output;
   end
end

%curv_final{1}{1}=curv_final{1}{1}*generate_csf(0.5,n_scales,nu_0,channel);


switch (multires)
   case 'curv'
      img_out = ifdct_wrapping(curv_final,1,size(img_in,1),size(img_in,2));
   case 'a_trous'
      c{n_scales-1}=curv_final{1}{1};
      for s=2:n_scales
         for o=1:3
            w{s-1}(:,:,o)=curv_final{s}{o};
         end
      end
      img_out = Ia_trous(w,c);
   case 'wav'
      c{n_scales-1}=curv_final{1}{1};
      for s=2:n_scales
         for o=1:3
            w{s-1}(:,:,o)=curv_final{s}{o};
         end
      end
      img_out = IDWT(w,c,size(img,2), size(img,1));
   case 'wav_contrast'
      c{n_scales-1}=curv_final{1}{1};
      for s=2:n_scales
         for o=1:3
            w{s-1}(:,:,o)=curv_final{s}{o};
         end
      end
      img_out = IDWT_contrast(w,c,size(img,2), size(img,1));
	case 'gabor'
		img_out=IGaborTransform_XOP(curv_final,n_scales,Ls);
   otherwise
      disp('ERROR: No valid multiresolution decomposition method');
   return;   
end

% figure,plot(squeeze(gx_final(1,164,:)));	% evolucio temporal
% figure,plot(squeeze(gx_final(1,:,niter)));	% perfil final
% 
% figure,plot(squeeze(gy_final(1,164,:)));
% figure,plot(squeeze(gy_final(1,:,niter)));
%
% figure,plot(mean(squeeze(gx_final),2));
 

