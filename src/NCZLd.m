function [img,img_out] = NCZLd(img,struct)

% from general_NCZLd.m to NCZLd_channel_v1_0.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% START - TIC! %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time
t_ini=tic;
devlog(int2str(size(img(:,:,1))) );

%-------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calc scales %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

if(struct.wave.n_scales==0)
    [struct.wave.n_scales struct.wave.ini_scale struct.wave.fin_scale]= NCZLd_calcscales(img, struct.wave.ini_scale, struct.wave.fin_scale_offset, struct.wave.mida_min, struct.wave.multires); % calculate number of scales (n_scales) automatically
end

[struct.wave.n_orient] = calc_norient(img,struct.wave.multires,struct.wave.n_scales,struct.zli.n_membr);


%-------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% copy image for each frame    %%%
%%% (static = keep image         %%%
%%% dynamic = copy n_membr times %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if struct.compute.dynamic==1 % handle all the frames (dynamic)
        opp = dyncopy(img,struct.zli.n_membr);
    else  % (static)
        opp=img;
end

% L'estimul donat per generate_colinduct_stim esta en l'espai lsY  
% on l  % i s son els canals cromatics i Y es el d'intesitat.  
 %save([struct.compute.outputstr '' image.name,'opponent_in.mat'], 'opp');
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% NCZLd for every channel %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[opp_out] =NCZLd_dispatcher(img, opp,struct);


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% copy n_membr times %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

img_out = dyncopy(opp_out,struct.zli.n_membr); %img_out = opp_out


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Plot and store %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NCZLd_plot_results(img, img_out, struct);

NCZLd_store_results(img, img_out, struct);

store_matrix_givenparams(struct,'struct',struct);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Static case - compute mean of frames (that was copied n_membr times) %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if struct.compute.dynamic==0
    img_out = static_computeframesmean(img_out , struct.zli.n_membr,struct.zli.n_frames_promig);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% END - TOC! %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time
toc(t_ini)
end



%---

function [n_scales ini_scale fin_scale] = NCZLd_calcscales(img, ini_scale, fin_scale_offset, mida_min, multires)

    
        if(fin_scale_offset==0)
            extra=2;  % parameter to adjust the correct number of the last wavelet plane (obsolete)
        else
            extra=3;
        end

        switch(multires)
            case('gabor_HMAX')
                n_scales=8;
                fin_scale=n_scales;
    % 		case('a_trous')
    % 			n_scales=6;
                %fin_scale= struct.wave.n_scales - struct.wave.fin_scale_offset;
            otherwise
                n_scales=floor(log(max(size(img(:,:,1))-1)/mida_min)/log(2)) + extra;
    %			n_scales=floor(log2(	min(size(img(:,:,1)))-1) )-n_scale_max;
                fin_scale= n_scales - fin_scale_offset;
        end
    
    %%a_trous uses same scaling per scale (wont crash), other decomp. would crash afterwards
    
end



%---

function [job] = NCZLd_createjob(jobmanager, dir)

        devlog('Executant els canals en paralel');
        p=dir;

        jm=findResource('scheduler','type','jobmanager','Name',jobmanager,'LookupURL','localhost');
        get(jm);
        job = createJob(jm);
        set(job,'FileDependencies',p)
        set(job,'PathDependencies',p)
        get(job)
end

%-----

function [opp_out] =NCZLd_dispatcher(im, opp,struct)
    channel_type={'chromatic', 'chromatic2', 'intensity'};
    
   
    
    if struct.compute.HDR==1    %2 channels
        [opp_out] = NCZLd_CORE_HDR(im,opp,channel_type,struct);
    else                        %3 channels
        [opp_out] = NCZLd_CORE_NOHDR(im,opp,channel_type,struct);
    end
    
    
end

function [opp_out] = NCZLd_CORE_HDR(img,opp,channel_type,struct)
     % opp_out(:,:,1:3,:)=zeros(size(opp,1),size(opp,2),3,size(opp,4));
    opp_out=zeros(size(img,1),size(img,2),3,struct.zli.n_membr); % process channels separetely, preallocate mem
    %opp_out = zeros([size(opp) struct.zli.n_membr]); %fixed size= optimized (preallocated speed) %4 dims: x,y,channel,time
    
    for i=1:2
		if struct.compute.dynamic==0
			for ff=1:struct.zli.n_membr
				opp_out(:,:,i,ff)=double(opp(:,:,i)); %copy frames %!duplicitat aqui
			end
        end
    end
    im=double(opp(:,:,3,:));
    %opp_out(:,:,3,:)=NCZLd_channel_v1_0(im,struct,channel_type{i});
    opp_out(:,:,3,:)=NCZLd_channel_v1_0Xim(im,struct,channel_type{i}); %!algo se hace mal aqui
end

function [opp_out] = NCZLd_CORE_NOHDR(img,opp,channel_type,struct)
    
    
    opp_out=zeros(size(img,1),size(img,2),3,struct.zli.n_membr); % process channels separetely, preallocate mem
    
    
    for i=1:3
        im=double(opp(:,:,i)); %! duplicitat aqui

        if(struct.compute.parallel_channel==1)
             job = NCZLd_createjob(struct.compute.jobmanager, struct.compute.dir); %create job
             
             task = NCZLd_CORE_PARALLEL(job,im, i,channel_type, struct); %task created (not use itm,recall results afterwards)

             
        else
             out = NCZLd_CORE_ITERATIVE(im, i,channel_type, struct);
             opp_out(:,:,i,:) = out;

        end
    end
    
     for i=1:3
             if(struct.compute.parallel_channel==1) 
                 out = NCZLd_copyresults_parallel(job,i,struct); %recall job results
                 opp_out(:,:,i,:) = out;
             end
     end
     
    
end

function [t] = NCZLd_CORE_PARALLEL(job,im, channel, channel_type, struct)
    %t=createTask(job, @NCZLd_channel_v1_0, 1, {im,struct,channel_type{channel}});
     t=createTask(job, @NCZld_channel_v1_0Xim, 1, {im,struct,channel_type{channel}});
end

function [opp_out] = NCZLd_CORE_ITERATIVE(im,channel, channel_type, struct)
    %opp_out(:,:,channel,:)=NCZLd_channel_v1_0(im,struct,channel_type{channel});
        opp_out=NCZLd_channel_v1_0Xim(im,struct,channel_type{channel}); %x,y,time
end

function [opp_out] = NCZLd_copyresults_parallel(job,ch_it,struct)
    
    if(struct.compute.parallel_channel==1)
        submit(job);
        get(job,'Tasks')
        waitForState(job, 'finished');
        job.Tasks(ch_it).ErrorMessage;
        out = getAllOutputArguments(job);
        %opp_out=zeros(size(img,1),size(img,2),3,struct.zli.n_membr); % process channels separetely, preallocate mem
        opp_out=out{ch_it};
        destroy(job);
    end
end

%---


function [] = NCZLd_plot_results(img, img_out, struct)

end

function [] = NCZLd_store_results(img, img_out, struct)

    %save([struct.compute.outputstr '' image.name,'opponent_out.mat'], 'opp_out');
    
    % store/ don't store img and img_out (warning: img_out is 4D in the dynamical case!)
    %if struct.display_plot.store_img_img_out==1
        %save([struct.compute.outputstr '' image.name, '_img.mat'],'img')
        %save([struct.compute.outputstr '' image.name, '_img_out.mat'],'img_out')

    %end

end



function [n_orient] = calc_norient(img,method,n_scales,n_membr)
    switch (method)
       case 'curv'
           for ff=1:n_membr
                c = fdct_wrapping(img(:,:,ff),1,1,n_scales);
                n_orient = zeros(n_scales);
                for s=1:n_scales
                    n_orient(s)=size(c{s},2);
                end
           end
           
       case 'a_trous'
           n_orient = 3;
       case 'a_trous_contrast'
           n_orient = 3;
       case 'wav'
           n_orient = 3;
       case 'wav_contrast'
           n_orient = 3;
       case 'gabor'
           n_orient = 4;
       case 'gabor_HMAX'
           n_orient = 4;
        otherwise 
            n_orient = 3;
       
    end
       
end


















