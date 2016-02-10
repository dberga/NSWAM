function [img_out] = NCZLd_channel_v1_0Xim(img_in,struct,channel)

img_in = double(img_in);


% from NCZLd_channel_v1_0.m to NCZLd_channel_ON_OFF_v1_1.m

% perform the wavelet decomposition and its inverse transform

% img_in: monochromatic input image (i.e. one channel)
%-------------------------------------------------------

devlog('Ha entrat a la funcio NCZLd_channel_v1_0Xim');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% discriminate if image is uniform %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[cond, img_out] = NCZLd_channel_discriminateuniform(img_in); %! duplicitat, s'hauria de fer a NCZLd
if cond==true
    return;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% wavelet decomposition %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
    
[curv, w, c, Ls] = NCZLd_channel_DWTdispatcher(img_in,  struct.compute.dynamic, struct.wave.multires,struct.wave.n_scales, struct.zli.n_membr);

[curv] = NCZLd_channel_DWTdispatcher_replicatestatic(curv,struct.compute.dynamic,struct.wave.n_scales,struct.zli.n_membr); %! duplicitat, s'hauria de fer a NCZLd

%[mean_orig] = NCZLd_channel_DWTdispatcher_residualmean(curv,struct.wave.fin_scale,struct.wave.n_scales,struct.zli.n_membr); %not used





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% display dwt (curv) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


NCZLd_channel_display_afterdwt(img_in,curv,struct);

%%%%%%%%%%%%DISPLAY EACH FRAME
%figs_out = NCZLd_channel_display_example_per_time(curv,1,struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3,channel);
%for ff=1:struct.zli.n_membr
%    NCZLd_channel_figure_display(figs_out(ff),'jpg',struct.compute.outputstr,'curv','',channel,int2str(ff));
%end

%%%%%%%%%%%%DISPLAY ONLY MEAN OF FRAMES (option1=all frames, option2=1 to half, option3=half to end)
%tcurv = NCZLd_channel_tmean_image(curv,1,struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%tcurv = NCZLd_channel_tmean_image(curv,1,floor(struct.zli.n_membr/2),struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%tcurv = NCZLd_channel_tmean_image(curv,ceil(struct.zli.n_membr/2),struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%fig_out = NCZLd_channel_display_texample(tcurv,struct.wave.ini_scale,struct.wave.fin_scale,1,3,channel);
%NCZLd_channel_figure_display(fig_out,'jpg',struct.compute.outputstr,'curv','',channel);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% here is the CORE of the process -> NCZLd_channel_ON_OFF_v1_1 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

    
[iFactor, curv_final] = NCZLd_channel_dispatcher(curv,struct,channel);

toc



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   display iFactor (output of model)   %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%DISPLAY EACH FRAME
%figs_out = NCZLd_channel_display_example_per_time(iFactor,1,struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3,channel);
%for ff=1:struct.zli.n_membr
%    NCZLd_channel_figure_display(figs_out(ff),'jpg',struct.compute.outputstr,struct.image.single,'',channel,int2str(ff));
%end

%%%%%%%%%%%%DISPLAY ONLY MEAN OF FRAMES (option1=all frames, option2=1 to half, option3=half to end)
%tiFactor = NCZLd_channel_tmean_image(iFactor,1,struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%tiFactor = NCZLd_channel_tmean_image(iFactor,1,floor(struct.zli.n_membr/2),struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%tiFactor = NCZLd_channel_tmean_image(iFactor,ceil(struct.zli.n_membr/2),n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%fig_out = NCZLd_channel_display_texample(tiFactor,struct.wave.ini_scale,struct.wave.fin_scale,1,3,channel);
%NCZLd_channel_figure_display(fig_out,'jpg',struct.compute.outputstr,struct.image.single,'',channel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   calc and apply eCSF   %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






[eCSF] = NCZLd_channel_calceCSF(iFactor,curv,struct.wave.n_scales,struct.wave.ini_scale,struct.wave.fin_scale,struct.zli.n_membr,channel, struct.zli.nu_0, struct.wave.csf_params);
[curv_final] = NCZLd_channel_applyeCSF(eCSF,curv_final,struct.wave.ini_scale,struct.wave.fin_scale,struct.zli.n_membr);



 NCZLd_channel_store_aftereCSF(eCSF,curv,channel,struct);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   display eCSF (output of eCSF) and curv_final (output of eCSF*iFactor)   %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%DISPLAY EACH FRAME (eCSF)
%figs_out = NCZLd_channel_display_example_per_time(eCSF,1,struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3,channel);
%for ff=1:struct.zli.n_membr
%    NCZLd_channel_figure_display(figs_out(ff),'jpg',struct.compute.outputstr,struct.image.single,'',channel,int2str(ff));
%end

%%%%%%%%%%%%DISPLAY ONLY MEAN OF FRAMES (option1=all frames, option2=1 to half, option3=half to end)
%teCSF = NCZLd_channel_tmean_image(eCSF,1,struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%teCSF = NCZLd_channel_tmean_image(eCSF,1,floor(struct.zli.n_membr/2),struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%teCSF = NCZLd_channel_tmean_image(eCSF,ceil(struct.zli.n_membr/2),struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%fig_out = NCZLd_channel_display_texample(teCSF,struct.wave.ini_scale,struct.wave.fin_scale,1,3,channel);
%NCZLd_channel_figure_display(fig_out,'jpg',struct.compute.outputstr,'eCSF','',channel);

%%%%%%%%%%%%DISPLAY EACH FRAME (curv_final)
%figs_out = NCZLd_channel_display_example_per_time(curv_final,1,struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3,channel);
%for ff=1:struct.zli.n_membr
%    NCZLd_channel_figure_display(figs_out(ff),'jpg',struct.compute.outputstr,'curv_final','',channel,int2str(ff));
%end

%%%%%%%%%%%%DISPLAY ONLY MEAN OF FRAMES (option1=all frames, option2=1 to half, option3=half to end)
%tcurv_final = NCZLd_channel_tmean_image(curv_final,1,struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%tcurv_final = NCZLd_channel_tmean_image(curv_final,1,floor(struct.zli.n_membr/2),struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%tcurv_final = NCZLd_channel_tmean_image(curv_final,ceil(struct.zli.n_membr/2),struct.zli.n_membr,struct.wave.ini_scale,struct.wave.fin_scale,1,3);
%fig_out = NCZLd_channel_display_texample(tcurv_final,struct.wave.ini_scale,struct.wave.fin_scale,1,3,channel);
%NCZLd_channel_figure_display(fig_out,'jpg',struct.compute.outputstr,'curv_final','',channel);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Change curv_final for IDWT (choose iFactor, eCSF or eCSF*iFactor) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[curv_final] = NCZLd_channel_outputfromcsf(curv_final, iFactor, eCSF ,struct.zli.n_membr,struct.wave.fin_scale,struct.compute.output_from_csf);
[curv_final] = NCZLd_channel_outputfromresidu(curv_final, struct.zli.n_membr, struct.wave.fin_scale, struct.compute.output_from_residu);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INVERSE wavelet decomposition %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[img_out] = NCZLd_channel_IDWTdispatcher(curv_final,img_in,struct.wave.ini_scale,struct.wave.fin_scale,struct.wave.fin_scale,struct.zli.n_membr,struct.wave.multires,w,c,Ls);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   display image_out (IDWT of curv_final   %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NCZLd_channel_display_out(curv_final,iFactor,img_in,img_out,struct);


% for ff=1:struct.zli.n_membr
%     %disp(uint8(img_out(:,:,ff)));
%     fig_out = imshow(uint8(img_out(:,:,ff)));
%     %figs_out(ff) = fig_out;
%     NCZLd_channel_figure_display(fig_out,'jpg',struct.compute.outputstr,['imgout_t(' int2str(ff) ')'],'',channel,int2str(ff));
%     
% end

%timgout = NCZLd_channel_gettemporalMean2(img_out,1,struct.zli.n_membr);
%timgout = NCZLd_channel_gettemporalMean2(img_out,1,floor(struct.zli.n_membr/2));
%timgout = NCZLd_channel_gettemporalMean2(img_out,ceil(struct.zli.n_membr/2),struct.zli.n_membr);
%fig_out = imshow(uint8(timgout(:,:)));
%NCZLd_channel_figure_display(fig_out,'jpg',struct.compute.outputstr,'img_out_','',channel);




end



function [cond img_out] = NCZLd_channel_discriminateuniform(img_in)
    
    img_out=img_in;
    
    % trivial case (if the image is uniform we do not process it!)
    if max(img_in(:))==min(img_in(:))    
        img_out=img_out+min(img_in(:)); % give the initial value to all the pixels
        % 	iFactor=img_in*0;
        devlog('Image is uniform');
        cond = true;
        return;
    else
        cond = false;
    end
    

end

function [curv w c Ls] = NCZLd_channel_DWTdispatcher(img, stimulus_type, method,n_scales, n_membr)

    w = 0; %output of wavelets
    c = 0; %output of every method
    Ls = 0; %output of gabor methods
    curv=cell([n_membr,n_scales,1]);

   % number of wavelet decompositions to perform
    if stimulus_type==1
        niter_wav=n_membr;
    else
        niter_wav=1;
    end

    % different wavelet decompositions		
    switch (method)
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
          devlog('ERROR: No valid multiresolution decomposition method',4);
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
    

end



 
function [curv] = NCZLd_channel_DWTdispatcher_replicatestatic(curv,stimulus_type,n_scales,n_membr)

    % replicate wavelet planes if static stimulus
    if stimulus_type==0
        devlog(strcat('Nombre scales a la funci channel_v1_0: ', num2str(n_scales)));
        for s=1:n_scales
            for o=1:size(curv{1}{s},2)
                for ff=2:n_membr
                    curv{ff}{s}{o}=curv{1}{s}{o};
                end
            end
        end
    end

end


function [] = NCZLd_channel_display_afterdwt(img,curv,struct)

% display img and curv if needed
if(struct.display_plot.plot_io==1)
	Mostrar_img_video(img,struct.display_plot.y_video, struct.display_plot.x_video);
	Mostrar_curv_video_POOL(curv,n_scales,1, struct.display_plot.y_video, struct.display_plot.x_video);
end

end


function [mean_orig] = NCZLd_channel_DWTdispatcher_residualmean(curv,fin_scale,n_scales,n_membr)

    % mean value of residual planes
    if fin_scale==n_scales
        mean_orig =cell(n_membr);
        for ff=1:n_membr
            mean_orig{ff}=mean(curv{ff}{n_scales}{1}(:));
        end
    else
        mean_orig = 0;%no mean
    end
end


function [iFactor curv_final] = NCZLd_channel_prepareout(curv,n_scales,n_membr)


% wavelet decomposition output
curv_final=curv;			% in order to define it with the same structure/preallocate
iFactor=curv;               % in order to define it with the same structure/preallocate
for ff=1:n_membr
    for scale=1:n_scales
        n_orient=size(iFactor{ff}{scale},2);
        for o=1:n_orient
            iFactor{ff}{scale}{o}(:)=1.;
        end
    end
end

end

function [iFactor curv_final] = NCZLd_channel_dispatcher(curv,struct,channel)

        % parallel/non parallel channels
        if(struct.compute.parallel_scale==1)
            job = NCZLd_channel_createjob(struct.compute.jobmanager, struct.compute.dir);
            t=createTask(job, @NCLZd_channel_ON_OFF_v1_1, 1, {curv,struct,channel});
            [iFactor curv_final] = NCZLd_copyresults_parallel(job,struct);
        else % no parallel
            % [curvtmp_final,iFactortmp]=Rmodelinductiond_v0_3_2(curv_tmp,struct);

            curv_final=NCZLd_channel_ON_OFF_v1_1(curv,struct,channel);
            iFactor=curv_final;
        %     load([image.name '_iFactor' channel 'nstripes' num2str(struct.image.nstripes) '.mat']);
        % 	curv_final = iFactor;

        end
	
end

function [job] = NCZLd_channel_createjob(jobmanager, dir)


        devlog('Executant els canals en paralel');
        p=dir;

        jm=findResource('scheduler','type','jobmanager','Name',jobmanager,'LookupURL','localhost');
        get(jm);
        job = createJob(jm);
        set(job,'FileDependencies',p)
        set(job,'PathDependencies',p)
        get(job)
        
        
end

function [iFactor curv_final] = NCZLd_copyresults_parallel(job,struct)
     
    [iFactor curv_final] = NCZLd_channel_prepareout(curv,struct.wave.n_scales,struct.zli.n_membr);
     
    % copy results (only parallel)
    if(struct.compute.parallel_scale==1)
        submit(job)
        get(job,'Tasks')
         %job;
        waitForState(job, 'finished');
         for i=struct.wave.ini_scale:struct.wave.fin_scale
             job.Tasks(i-struct.wave.ini_scale+1).ErrorMessage
         end
        out = getAllOutputArguments(job);
        for scale=struct.wave.ini_scale:struct.wave.fin_scale
    %        n_orient=size(curv{scale},2);
    %        for orient=1:n_orient
                for ff=1:struct.zli.n_membr
                 curv_final{ff}{scale}=out{scale-ini_scale+1}{1}{ff};
                 iFactor{ff}{scale}=out{scale-ini_scale+1}{2}{ff};
                end
    %        end
        end
        destroy(job);
    end

end


function [eCSF] = NCZLd_channel_calceCSF(iFactor,curv,n_scales,ini_scale,fin_scale,n_membr,channel, nu_0, csf_params)


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
    eCSF=cell([n_membr,n_scales,1]);
    for ff=1:n_membr
        for scale=ini_scale:fin_scale
            n_orient=size(curv{1}{scale},2);
            for o=1:n_orient
    %             		curv_final{ff}{scale}{i}=curv_final{ff}{scale}{i};
    % 	      		eCSF{ff}{scale}{o}=generate_csf(iFactor{ff}{scale}{o}(:,:), scale,zli.nu_0,'intensity');
                eCSF{ff}{scale}{o}=generate_csf(iFactor{ff}{scale}{o}(:,:), scale,nu_0,channel,csf_params);
                
                
                
                
                % 		curv_final{ff}{scale}{o}=curv{ff}{scale}{o}.*generate_csf(iFactor{ff}(:,:,scale,o),scale,zli.nu_0,'intensity')*0.5;
                
    %              curv_final{ff}{scale}{i}=curv_final{ff}{scale}{i}*generate_csf(0.5,scale,zli.nu_0,'intensity')*0.5;
            end
        end
    end


end


function [curv_final] = NCZLd_channel_applyeCSF(eCSF,curv,ini_scale,fin_scale,n_membr)
    
    for ff=1:n_membr

        for scale=ini_scale:fin_scale
            n_orient=size(curv{1}{scale},2);
            for o=1:n_orient

                curv_final{ff}{scale}{o}=curv{ff}{scale}{o}.*eCSF{ff}{scale}{o}*1.0;
            end

        end
    end

    
end

function [] = NCZLd_channel_store_aftereCSF(eCSF,curv,channel,struct)
    
save([struct.compute.outputstr '' struct.image.name '_eCSF' channel 'nstripes' num2str(struct.image.nstripes) '.mat'],'eCSF');

end

function [curv_final] = NCZLd_channel_outputfromcsf(curv_final, iFactor, eCSF ,n_membr,n_scales,option)

    switch option
         case 'model'
            curv_final = iFactor; %nothing
         case 'eCSF'
             for ff=1:n_membr 
                eCSF{ff}{n_scales}{1} = curv_final{ff}{n_scales}{1}; %copy residu to eCSF
             end
             curv_final = eCSF; %alpha

         case 'model&eCSF'
             %do nothing; %M.*alpha(M.*w)

    end
end


function [curv_final] = NCZLd_channel_outputfromresidu(curv_final, n_membr, n_scales, option)

    switch option
    case 0 %residu a zero
         for ff=1:n_membr
            curv_final{ff}{n_scales}{1} = 0; %zeros(size(curv_final{ff}{n_scales}{1})); 
         end
    case 1 %conserva residu
        %do nothing
    end

end


function [img_out] = NCZLd_channel_IDWTdispatcher(curv_final,img_in,ini_scale,fin_scale,n_scales,n_membr,method,w,c,Ls)
    
    % N.B.: we only perform the inverse wavelet transform of the frames used for computing the
    % mean, and NOT of all the sequence !


    % inverse transform

    % prepare output image
    img_out=zeros(size(img_in,1),size(img_in,2),fin_scale-ini_scale+1);
    %img_out=zeros([size(img_in) n_membr]);
    %img_out=zeros(size(img_in));

    switch (method)
       case 'curv'
            for ff=1:n_membr
                for s=1:n_scales
                    n_orient=size(curv_final{ff}{s},2);
                    for o=1:n_orient
                        c{n_scales-s+1}{o}=curv_final{ff}{s}{o};
                    end
                end
                img_out(:,:,ff) = ifdct_wrapping(c,1,size(img_in,1),size(img_in,2));
            end
       case 'a_trous'
            for ff=1:n_membr
               for s=1:n_scales-1
                    for o=1:3
                        w{s}(:,:,o)=curv_final{ff}{s}{o};
                    end
                end
              c{n_scales-1}=curv_final{ff}{n_scales}{1};
                img_out(:,:,ff) = Ia_trous(w,c);
            end
       case 'a_trous_contrast'
            for ff=1:n_membr
               for s=1:n_scales-1
                    for o=1:3
                        w{s}(:,:,o)=curv_final{ff}{s}{o};
                    end
                end
              c{n_scales-1}=curv_final{ff}{n_scales}{1};
                img_out(:,:,ff) = Ia_trous_contrast(w,c);
            end
       case 'wav'
            for ff=1:n_membr
               for s=1:n_scales-1
                    for o=1:3
                        w{s}(:,:,o)=curv_final{ff}{s}{o};
                    end
                end
              c{n_scales-1}=curv_final{ff}{n_scales}{1};
                img_out(:,:,ff) = IDWT(w,c,size(img,2), size(img,1));
            end
       case 'wav_contrast'
            for ff=1:n_membr
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
end

function [] = NCZLd_channel_display_out(curv_final,iFactor,img_in,img_out,struct)

% 0/1 display it all
if(struct.display_plot.plot_io==1)
	Mostrar_curv_video_POOL(curv_final,struct.wave.n_scales,1, struct.display_plot.y_video, struct.display_plot.x_video);
end
end


function [figure_disp] = NCZLd_channel_display_example(image,frame,sinit,sfinal,oinit,ofinal,channel)
    

        figure_disp = figure;
        
        count = 0;
        for s=sinit:sfinal
            for o=oinit:ofinal
                count = count +1;
                
                
                subplot(length(sinit:sfinal),length(oinit:ofinal),count), subimage(image{frame}{s}{o}(:,:));
                title([channel '_t(' int2str(frame)  ')']);
                xlabel(['scale=' int2str(s)]);
                ylabel(['orientation' int2str(o)]);
                
                
            end
        end
        
        
        
end



    
function [figure_disp] = NCZLd_channel_display_example_per_time(image,tinit,tfinal,sinit,sfinal,oinit,ofinal,channel)
    if(nargin < 8 )
        channel = 'channel';
    end
    
    
    for ff=tinit:tfinal
        figure_disp(ff) = NCZLd_channel_display_example(image,ff,sinit,sfinal,oinit,ofinal,channel);
    end

end

    
function [tempMean] = NCZLd_channel_gettemporalMean(image,tinit,tfinal,s,o) 
    

    framesum = zeros(size(image{tinit}{s}{o}(:,:)));
    nframes = length(tinit:tfinal);
    
    for ff=tinit:tfinal
        framesum(:,:) = framesum(:,:) + image{ff}{s}{o}(:,:);    
    end
    tempMean(:,:) = framesum(:,:) ./ nframes;
    
end

    
function [tempMean] = NCZLd_channel_gettemporalMean2(image,tinit,tfinal) 
    

    framesum = zeros(size(image(:,:,tinit)));
    nframes = length(tinit:tfinal);
    
    for ff=tinit:tfinal
        framesum(:,:) = framesum(:,:) + image(:,:,ff);    
    end
    tempMean(:,:) = framesum(:,:) ./ nframes;
    
end


function [meanized_image] = NCZLd_channel_tmean_image(image,tinit,tfinal,sinit,sfinal,oinit,ofinal) 

        meanized_image = image;
        
       for s=sinit:sfinal
            for o=oinit:ofinal
                meanized_image{s}{o} = NCZLd_channel_gettemporalMean(image,tinit,tfinal,s,o);
            end
       end
       
       

end



function [figure_disp] = NCZLd_channel_display_texample(image,sinit,sfinal,oinit,ofinal,channel)
    

        figure_disp = figure;
        
        count = 0;
        for s=sinit:sfinal
            for o=oinit:ofinal
                count = count +1;
                
                
                subplot(length(sinit:sfinal),length(oinit:ofinal),count), subimage(image{s}{o}(:,:));
                title([channel '_t(mean)']);
                xlabel(['scale=' int2str(s)]);
                ylabel(['orientation' int2str(o)]);
                
                
            end
        end
        
end



function [] = NCZLd_channel_figure_display(figin,format,output_folder,output_prefix,output_suffix,channel,frame)
    if(nargin < 7)
        frame = 'mean';
    end
    
    saveas(figin,[output_folder output_prefix '_' channel '_t(' frame ')' '_' output_suffix '.' format]);
    
end







