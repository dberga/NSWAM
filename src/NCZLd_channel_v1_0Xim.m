function [img_out] = NCZLd_channel_v1_0Xim(img_in,struct,channel,nstripes)

% from NCZLd_channel_v1_0.m to NCZLd_channel_ON_OFF_v1_1.m

% perform the wavelet decomposition and its inverse transform

% img_in: monochromatic input image (i.e. one channel)
%-------------------------------------------------------
% make the structure explicit
zli=struct.zli;
wave=struct.wave;
compute=struct.compute;
image=struct.image;

% struct.zli
% normal_output=zli.normal_output;
n_membr=zli.n_membr;

% struct.wave
multires=wave.multires;
n_scales=wave.n_scales;
disp(strcat('Scales al entrar a la funcio channel_v1_0Xim: ', num2str(n_scales)));

% struct.compute
% parallel=compute.parallel;
dynamic=compute.dynamic;
%-------------------------------------------------------

disp('Ha entrat a la funcio NCZLd_channel_v1_0Xim');

% scales we consider
ini_scale=zli.ini_scale 
fin_scale=n_scales - zli.fin_scale_offset


switch(wave.multires)
	case 'gabor_HMAX'
		fin_scale=n_scales;
end

struct.wave.fin_scale=fin_scale;
% preallocation
if dynamic~=1
    img_out=zeros([size(img_in) n_membr]);
else
    img_out=zeros(size(img_in));
end
% trivial case (if the image is uniform we do not process it!)
if max(img_in(:))==min(img_in(:))
    %    img_out=img_in;
    img_out=img_out+min(img_in(:)); % give the initial value to all the pixels
    % 	iFactor=img_in*0;
    disp('Image is uniform');
    return;
end

% image
img=double(img_in); % obsolete?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% wavelet decomposition %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
curv=cell([zli.n_membr,n_scales,1]);

% number of wavelet decompositions to perform
if dynamic==1
	niter_wav=n_membr;
else
	niter_wav=1;
end
		
% different wavelet decompositions		
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
		for ff=1:niter_wav  % note: that's for videos only
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
   case 'gabor_HMAX'
% 		for ff=1:niter_wav
			[curvGabor,n_scales]=Gabor_decomposition(img);
			disp(['gabor_HMAX n_scales:' int2str(n_scales)]);
% 		end
        % we now have to transform the Gabor format into the curv format
        for ff=1:niter_wav
			
			for s=1:n_scales
				for o=1:4
					curv{ff}{s}{o}=curvGabor{ff}{s}{o};
				end
			end
			
		end
   otherwise
      disp('ERROR: No valid multiresolution decomposition method');
      return;
end

% induce artificila activity to a given neuron population (Rossi and Paradiso, 1999, Figure 2.3)
% 	for s=1:n_scales
% 		for o=1:size(curv{1}{s},2)
% 			for ff=1:niter
% 				curv{ff}{s}{o}(65,65)=0.2;
% 			end
% 		end
% 	end

iFactor=curv;

% replicate wavelet planes if static stimulus
if dynamic~=1
	disp(strcat('Nombre scales a la funci channel_v1_0: ', num2str(n_scales)));
	for s=1:n_scales
		for o=1:size(curv{1}{s},2)
			for ff=2:n_membr
				curv{ff}{s}{o}=curv{1}{s}{o};
			end
		end
	end
end

% display img and curv if needed
if(struct.display_plot.plot_io==1)
	Mostrar_img_video(img,struct.display_plot.y_video, struct.display_plot.x_video);
	Mostrar_curv_video_POOL(curv,n_scales,1, struct.display_plot.y_video, struct.display_plot.x_video);
end

% mean value of residual planes
if fin_scale==n_scales
	for ff=1:n_membr
		mean_orig{ff}=mean(curv{ff}{n_scales}{1}(:));
	end
end


% wavelet decomposition output
curv_final=curv;			% in order to define it with the same structure
iFactor=curv;               % in order to define it with the same structure

for ff=1:n_membr
    for scale=1:n_scales
        n_orient=size(iFactor{ff}{scale},2);
        for o=1:n_orient
            iFactor{ff}{scale}{o}(:)=1.;
        end
    end
end

% cluster
if(compute.parallel_scale==1)
	p=compute.dir;
	jm=findResource('scheduler','type','jobmanager','Name',compute.jobmanager,'LookupURL','localhost');
	get(jm)
	job = createJob(jm);
	set(job,'FileDependencies',p)
	set(job,'PathDependencies',p)
	get(job)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% here is the CORE of the process -> NCZLd_channel_ON_OFF_v1_1 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
% parallel/non parallel channels
if(compute.parallel_scale==1)
    t=createTask(job, @NCLZd_channel_ON_OFF_v1_1, 1, {curv,struct,channel,nstripes});
else % no parallel
    % [curvtmp_final,iFactortmp]=Rmodelinductiond_v0_3_2(curv_tmp,struct);
    
	curv_final=NCZLd_channel_ON_OFF_v1_1(curv,struct,channel, nstripes);
	iFactor=curv_final;
%     load([image.name '_iFactor' channel 'nstripes' num2str(nstripes) '.mat']);
% 	curv_final = iFactor;
	
end
	
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   end of the core   %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% copy results (only parallel)
if(compute.parallel_scale==1)
    submit(job)
    get(job,'Tasks')
	 job;
    waitForState(job, 'finished');
	 for i=ini_scale:fin_scale
		 job.Tasks(scale-ini_scale+1).ErrorMessage
	 end
    out = getAllOutputArguments(job);
    for scale=ini_scale:fin_scale
%        n_orient=size(curv{scale},2);
%        for orient=1:n_orient
			for ff=1:n_membr
             curv_final{ff}{scale}=out{scale-ini_scale+1}{1}{ff};
             iFactor{ff}{scale}=out{scale-ini_scale+1}{2}{ff};
			end
%        end
    end
    destroy(job);
end

% e-CSF Xim calculated using iFactorMig
% eCSF=cell([n_scales,1]);
% iFactorMig = calcular_iFactorMig(iFactor, zli.n_membr, fin_scale-ini_scale+1, size(curv{1}{1},2));
% for scale=ini_scale:fin_scale
% 	n_orient=size(curv{1}{scale},2);
% 	for o=1:n_orient
% 		%Calculem la eCSF
% 		eCSF{scale}{o}=generate_csf(iFactorMig{scale}{o}, scale,zli.nu_0, channel, 'Xavier');
% 		for ff=1:n_membr
% 			%Apliquem la eCSF
% 			curv_final{ff}{scale}{o}=curv{ff}{scale}{o}.*eCSF{scale}{o}*1.0;
% 
% 			%NO apliquem la eCSF
% 			%curv_final{ff}{scale}{o}=curv{ff}{scale}{o}.*iFactorMig{scale}{o}*1.5;
% 		end
% 	end
% end

%% eCSF Xim calculated using iFactor i aplicant la eCSFMitja
%eCSF=cell([zli.n_membr,n_scales,1]);
%for scale=ini_scale:fin_scale
%       n_orient=size(curv{1}{scale},2);
%       for o=1:n_orient
%               for ff=1:n_membr
%			%Calculem la eCSF
%			eCSF{ff}{scale}{o}=generate_csf(iFactor{ff}{scale}{o}, scale,zli.nu_0, channel, 'Xavier');
%               end
%	end
%end
%% Calculem la eCSFMitja
%eCSFMitja = calcular_eCSFMitja(eCSF, zli.n_membr, fin_scale-ini_scale+1, size(curv{1}{1},2));
%for ff=1:n_membr
%	for scale=ini_scale:fin_scale
%		n_orient=size(curv{1}{scale},2);
%		for o=1:n_orient
%			%Apliquem la eCSFMitja
%			curv_final{ff}{scale}{o}=curv{ff}{scale}{o}.*eCSFMitja{scale}{o}*1.0;
%		end
%	end
%end

% e-CSF (experimental part, no modification by default)
eCSF=cell([zli.n_membr,n_scales,1]);
for ff=1:n_membr
	for scale=ini_scale:fin_scale
		n_orient=size(curv{1}{scale},2);
		for o=1:n_orient
%             		curv_final{ff}{scale}{i}=curv_final{ff}{scale}{i};
% 	      		eCSF{ff}{scale}{o}=generate_csf(iFactor{ff}{scale}{o}(:,:), scale,zli.nu_0,'intensity');
			eCSF{ff}{scale}{o}=generate_csf(iFactor{ff}{scale}{o}(:,:), scale,zli.nu_0,channel,'Xavier');
            % 		curv_final{ff}{scale}{o}=curv{ff}{scale}{o}.*generate_csf(iFactor{ff}(:,:,scale,o),scale,zli.nu_0,'intensity')*0.5;
			curv_final{ff}{scale}{o}=curv{ff}{scale}{o}.*eCSF{ff}{scale}{o}*1.0;
%              curv_final{ff}{scale}{i}=curv_final{ff}{scale}{i}*generate_csf(0.5,scale,zli.nu_0,'intensity')*0.5;
		end
	end
end

 
 
     

save([struct.compute.outputstr '' image.name '_eCSF' channel 'nstripes' num2str(nstripes) '.mat'],'eCSF');
% number of frames (among the last ones) we use when we consider the mean
n_frames_promig=struct.image.n_frames_promig;
ff_ini=1;
ff_fin=n_membr;
% prepare output image
img_out=zeros(size(img,1),size(img,2),ff_fin-ff_ini+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INVERSE wavelet decomposition %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% N.B.: we only perform the inverse wavelet transform of the frames used for computing the
% mean, and NOT of all the sequence !

switch struct.compute.output_from_csf
     case 'model'
        curv_final = iFactor; %nothing
     case 'eCSF'
         for ff=ff_ini:ff_fin
            eCSF{ff}{n_scales}{1} = curv_final{ff}{n_scales}{1}; %copy residu to eCSF
         end
         curv_final = eCSF; %alpha
         
     case 'model&eCSF'
         %do nothing; %M.*alpha(M.*w)
         
end

switch struct.compute.output_from_residu
    case 0 %residu a zero
         for ff=ff_ini:ff_fin
            curv_final{ff}{n_scales}{1} = 0; %zeros(size(curv_final{ff}{n_scales}{1})); 
         end
    case 1 %conserva residu
        %do nothing
end


% inverse transform
switch (multires)
   case 'curv'
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
   case 'gabor_HMAX'
      disp('No valid multiresolution decomposition method for Gabor_HMA ... img_out=img*0;');
		img_out=img*0;
   otherwise
      disp('ERROR: No valid multiresolution decomposition method');
   return;   
end

% 0/1 display it all
if(struct.display_plot.plot_io==1)
	Mostrar_curv_video_POOL(curv_final,n_scales,1, struct.display_plot.y_video, struct.display_plot.x_video);
end

end


 

