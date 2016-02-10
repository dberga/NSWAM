function [img,img_out] = NCZLd(img,struct, nstripes)

% from general_NCZLd.m to NCZLd_channel_v1_0.m

% time
t_ini=tic;

%-------------------------------------------------------
% get the structure/parameters
wave=struct.wave;
zli=struct.zli;
compute=struct.compute;
image=struct.image;
n_membr=zli.n_membr;
% struct.wave
multires=wave.multires;
n_scales=wave.n_scales;
mida_min=wave.mida_min;
% struct.image
gamma=image.gamma; % It isn't used
updown=image.updown;
% struct.compute
% dynamic/constant
dynamic=compute.dynamic;
ini_scale=zli.ini_scale;
fin_scale=n_scales - zli.fin_scale_offset;
%-------------------------------------------------------
% size
disp([int2str(size(img(:,:,1))) ]);
% calculate number of scales (n_scales) automatically
if(n_scales==0)
	if(zli.fin_scale_offset==0)
		extra=2;  % parameter to adjust the correct number of the last wavelet plane (obsolete)
	else
		extra=3;
	end
	
	switch(wave.multires)
		case('gabor_HMAX')
			n_scales=8;
% 		case('a_trous')
% 			n_scales=6;
		otherwise
			n_scales=floor(log(max(size(img(:,:,1))-1)/mida_min)/log(2)) + extra
%			n_scales=floor(log2(	min(size(img(:,:,1)))-1) )-n_scale_max;
	end
end
% store
wave.n_scales=n_scales;
% actualize struct
struct.wave=wave;
%-------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% opponent channels %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% direct transform

if dynamic==1 % handle all the frames (dynamic)
    opp=zeros(size(img));
    for ff=1:zli.n_membr
        opp(:,:,:,ff)=img(:,:,:,ff);
    end    
else  % (static)
	% L'estimul donat per generate_colinduct_stim esta en l'espai lsY on l
    % i s son els canals cromatics i Y es el d'intesitat.  
    opp=img;
  %save([image.name,'opponent_in.mat'], 'opp');
%  	 opp=img;
end    

% process channels separetely
% opp_out(:,:,1:3,:)=zeros(size(opp,1),size(opp,2),3,size(opp,4));
opp_out=zeros(size(img,1),size(img,2),3,n_membr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% NCZLd for every channel %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(compute.parallel_channel==1)
    disp('Executant els canals en paralel');
    p=compute.dir;
    
    jm=findResource('scheduler','type','jobmanager','Name',compute.jobmanager,'LookupURL','localhost');
    get(jm);
    job = createJob(jm);
    set(job,'FileDependencies',p)
    set(job,'PathDependencies',p)
	get(job)
end

channel_type={'chromatic', 'chromatic2', 'intensity'};

if compute.HDR==1
	for i=1:2
		if dynamic==0
			for ff=1:n_membr
				opp_out(:,:,i,ff)=double(opp(:,:,i));
			end
		end
	end
	im=double(opp(:,:,3,:));
	%opp_out(:,:,3,:)=NCZLd_channel_v1_0(im,struct,channel_type{i}, nstripes);
	opp_out(:,:,3,:)=NCZLd_channel_v1_0Xim(im,struct,channel_type{i},nstripes);
	
else
    for i=1:3
        im=double(opp(:,:,i,:));
        if(compute.parallel_channel==1)
            %t=createTask(job, @NCZLd_channel_v1_0, 1, {im,struct,channel_type{i}, nstripes});
	    t=createTask(job, @NCZld_channel_v1_0Xim, 1, {im,struct,channel_type{i}, nstripes});
        else
            %opp_out(:,:,i,:)=NCZLd_channel_v1_0(im,struct,channel_type{i}, nstripes);
	    opp_out(:,:,i,:)=NCZLd_channel_v1_0Xim(im,struct,channel_type{i}, nstripes);
        end
    end
end

% Copy results 
if(compute.parallel_channel==1)
    submit(job);
    get(job,'Tasks')
    waitForState(job, 'finished');
    for i=1:3
        job.Tasks(i).ErrorMessage;
    end
    out = getAllOutputArguments(job);
    out
    for i=1:3
       opp_out(:,:,i,:)=out{i};
    end
    destroy(job);
end

%save([image.name,'opponent_out.mat'], 'opp_out');


	img_out=zeros(size(opp_out));
    for ff=1:n_membr
        img_out(:,:,:,ff)=opp_out(:,:,:,ff);
    end    


% store/ don't store img and img_out (warning: img_out is 4D in the dynamical case!)
if struct.display_plot.store_img_img_out==1
	%save([image.name, '_img.mat'],'img')
	%save([image.name, '_img_out.mat'],'img_out')
    
end


% static case
if dynamic==~1
    % take the mean (see Li, 1999)
	n_frames_promig=struct.image.n_frames_promig;

	ff_ini=n_membr-n_frames_promig+1;
	ff_fin=n_membr;
	
	kk=mean(img_out(:,:,:,ff_ini:ff_fin),4);
	img_out=zeros(size(kk));
	img_out=kk;
end

% time
toc(t_ini)
end
