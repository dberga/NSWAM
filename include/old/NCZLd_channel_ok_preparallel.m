function [img_out] = NCZLd_channel(img_in,struct,channel)

% img_in: monocromatic input image (i.e. one channel)

%-------------------------------------------------------
% make the structure explicit
zli=struct.zli;
wave=struct.wave;
compute=struct.compute;

% struct.zli
normal_output=zli.normal_output;
niter=zli.niter;

% struct.wave
multires=wave.multires;
n_scales=wave.n_scales;

% struct.compute
% parallel=compute.parallel;
dynamic=compute.dynamic;
%-------------------------------------------------------


% scales we consider
ini_scale=zli.ini_scale 
fin_scale=n_scales - zli.fin_scale_offset

% If image is uniform, we return and do not process!
if max(img_in(:))==min(img_in(:))
   img_out=img_in;
   return;
end

% image
img=double(img_in); % OP : necessari? ja ??s double no?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% wavelet decomposition %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
curv=cell([zli.niter,n_scales,1]);

% The number of wavelet decompositions to perform
if dynamic==1
	niter_wav=niter;
else
	niter_wav=1;
end
		

		
switch (multires)
   case 'curv'
		for ff=1:niter_wav
			c = fdct_wrapping(img(:,:,ff),1,1,n_scales);
			for s=1:n_scales
				n_orient=size(c{s},2);
				for o=1:n_orient
					curv{ff}{n_scales-s+1}{o}=c{s}{o};
				end
			end
		end
   case 'a_trous'
		for ff=1:niter_wav
	      [w c] = a_trous(img(:,:,ff), n_scales-1);
			for s=1:n_scales-1
				for o=1:3
					curv{ff}{s}{o}=w{s}(:,:,o);
				end
			end
			curv{ff}{n_scales}{1}=c{n_scales-1};
		end
   case 'a_trous_contrast'
		for ff=1:niter_wav
	      [w c] = a_trous_contrast(img(:,:,ff), n_scales-1);
			for s=1:n_scales-1
				for o=1:3
					curv{ff}{s}{o}=w{s}(:,:,o);
				end
			end
			curv{ff}{n_scales}{1}=c{n_scales-1};
		end
   case 'wav'
		for ff=1:niter_wav
			[w c] = DWT(img(:,:,ff), n_scales-1);
			for s=1:n_scales-1
				for o=1:3
					curv{ff}{s}{o}=w{s}(:,:,o);
				end
			end
			curv{ff}{n_scales}{1}=c{n_scales-1};
		end
   case 'wav_contrast'
		for ff=1:niter_wav
			[w c] = DWT_contrast(img(:,:,ff), n_scales-1);
			for s=1:n_scales-1
				for o=1:3
					curv{ff}{s}{o}=w{s}(:,:,o);
				end
			end
			curv{ff}{n_scales}{1}=c{n_scales-1};
		end
   case 'gabor'
		for ff=1:niter_wav
			[curv{ff},Ls{ff}]=GaborTransform_XOP(img(:,:,ff),n_scales);
		end
   otherwise
      disp('ERROR: No valid multiresolution decomposition method');
      return;
end


% Replicate wavelet planes if static stimulus
if dynamic~=1
	for s=1:n_scales
		for o=1:size(curv{1}{s},2)
			for ff=2:niter
				curv{ff}{s}{o}=curv{1}{s}{o};
			end
		end
	end
end

% Mean value of residual planes

if fin_scale==n_scales
	for ff=1:niter
		mean_orig{ff}=mean(curv{ff}{n_scales}{1}(:));
	end
end


% wavelet decomposition output
curv_final=curv;			% In order to define it with the same structure
% iFactor=curv_final;	% In order to define it with the same structure



if(compute.parallel_scale==1)
    p=compute.dir;
    jm=findResource('scheduler','type','jobmanager','Name',compute.jobmanager,'LookupURL','localhost');
    get(jm);
    job = createJob(jm);
    set(job,'FileDependencies',p)
    set(job,'PathDependencies',p)
	get(job)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% here is the CORE of the process (-> Qmodelinductiond_v0_0) %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for scale=ini_scale:fin_scale
	n_orient=size(curv{1}{scale},2);
	disp(['scale: ' int2str(scale) ', n_orient: ' int2str(n_orient)])

	% parallel_channel
    if(compute.parallel_scale==1)
        t=createTask(job, @NCZLd_channel_orient, 1, {curv,struct,scale});
    % no parallel
    else
        % isolate the scale
        % 3 orientations!!! FROM NOW ON, we handle double instead of cells
        % (that in NCZLd_channel_orient and Qmodelinductiond_v0_0)
		  curvtmp_final=NCZLd_channel_orient(curv,struct,scale);
%         curvs_final=curvs; % No faig res
		for ff=1:niter
			curv_final{ff}{scale}=curvtmp_final{ff}{scale};
		end
		
	 end
	 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copy results 
if(compute.parallel_scale==1)
    submit(job)
    get(job,'Tasks')
    waitForState(job, 'finished');
	for i=ini_scale:fin_scale
        job.Tasks(scale-ini_scale+1).ErrorMessage
    end
    out = getAllOutputArguments(job);
    for scale=ini_scale:fin_scale
%        n_orient=size(curv{scale},2);
%        for orient=1:n_orient
			for ff=1:niter
             curv_final{ff}{scale}=out{scale-ini_scale+1}{ff};
			end
%        end
    end
    destroy(job);
end


% e-CSF
for ff=1:niter
    for scale=ini_scale:fin_scale
		 n_orient=size(curv{1}{scale},2);
       for i=1:n_orient
            curv_final{ff}{scale}{i}=curv_final{ff}{scale}{i}*normal_output;
%             curv_final{ff}{scale}{i}=curv{ff}{scale}{i}.*generate_csf(curv_final{ff}{scale}{i},scale,zli.nu_0,'intensity')*0.5;
%              curv_final{ff}{scale}{i}=curv_final{ff}{scale}{i}*generate_csf(0.5,scale,zli.nu_0,'intensity')*0.5;
       end
    end
end



% Preserve the mean value of residual planes

% if fin_scale==n_scales
% 	for ff=1:niter
% 		mean_fin_inv=1/mean(curv_final{ff}{n_scales}{1}(:));
% 		curv_final{ff}{n_scales}{1}(:)=curv_final{ff}{n_scales}{1}(:)*mean_fin_inv*mean_orig{ff};
% 	end
% end




% Number of last frames we use to perform a mean for static stimulus

n_frames_promig=struct.image.n_frames_promig;

ff_ini=1;
ff_fin=niter;

if dynamic~=1
	ff_ini=niter-n_frames_promig+1;
	ff_fin=niter;
end



% Prepare output image
img_out=zeros(size(img,1),size(img,2),ff_fin-ff_ini+1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% inverse wavelet decomposition %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We only perform the inverse wavelet transform of the frames used for the
% mean, and NOT of all the sequence !!!!!

switch (multires)
   case 'curv'
		%       img_out = ifdct_wrapping(curv_final,1,size(img_in,1),size(img_in,2));
		
% 		for ff=1:niter_wav
% 			c = fdct_wrapping(img(:,:,ff),1,1,n_scales);
% 			for s=1:n_scales-1
% 				n_orient=size(c{s},2);
% 				for o=1:n_orient
% 					curv{ff}{s}{o}=c{s+1}{o};
% 				end
% 			end
% 			curv{ff}{n_scales}{1}=c{1}{1};
% 		end
%       img_out = ifdct_wrapping(curv_final,1,size(img_in,1),size(img_in,2));
		for ff=ff_ini:ff_fin
			for s=1:n_scales
				n_orient=size(curv_final{ff}{s},2);
				for o=1:n_orient
					c{n_scales-s+1}{o}=curv_final{ff}{s}{o};
				end
			end
			img_out(:,:,ff) = ifdct_wrapping(c,1,size(img_in,1),size(img_in,2));
		end
   case 'a_trous'
		for ff=ff_ini:ff_fin
		   for s=1:n_scales-1
				for o=1:3
					w{s}(:,:,o)=curv_final{ff}{s}{o};
				end
			end
	      c{n_scales-1}=curv_final{ff}{n_scales}{1};
			img_out(:,:,ff) = Ia_trous(w,c);
		end
   case 'a_trous_contrast'
		for ff=ff_ini:ff_fin
		   for s=1:n_scales-1
				for o=1:3
					w{s}(:,:,o)=curv_final{ff}{s}{o};
				end
			end
	      c{n_scales-1}=curv_final{ff}{n_scales}{1};
			img_out(:,:,ff) = Ia_trous_contrast(w,c);
		end
   case 'wav'
		for ff=ff_ini:ff_fin
		   for s=1:n_scales-1
				for o=1:3
					w{s}(:,:,o)=curv_final{ff}{s}{o};
				end
			end
	      c{n_scales-1}=curv_final{ff}{n_scales}{1};
			img_out(:,:,ff) = IDWT(w,c,size(img,2), size(img,1));
		end
   case 'wav_contrast'
		for ff=ff_ini:ff_fin
		   for s=1:n_scales-1
				for o=1:3
					w{s}(:,:,o)=curv_final{ff}{s}{o};
				end
			end
	      c{n_scales-1}=curv_final{ff}{n_scales}{1};
			img_out(:,:,ff) = IDWT_contrast(w,c,size(img,2), size(img,1));
		end
	case 'gabor'
		img_out=IGaborTransform_XOP(curv_final,n_scales,Ls);
   otherwise
      disp('ERROR: No valid multiresolution decomposition method');
   return;   
end

% If stimulus is static, we perform the mean
if dynamic~=1
	kk=mean(img_out(:,:,ff_ini:ff_fin),3);
	img_out=zeros(size(img,1),size(img,2),1);
	img_out(:,:,1)=kk;
	
	
end


end


 

