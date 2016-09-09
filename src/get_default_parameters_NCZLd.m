function [strct]=get_default_parameters_NCZLd()



[wave_params] = get_default_parameters_wave_NCZLd();
[zli_params] = get_default_parameters_zli_NCZLd();


    if strcmp(wave_params.multires,'gabor_HMAX') > 0
         zli_params.scale2size_type=-2;  % new gop14
    end
    
[csf_params] = get_default_parameters_csf_NCZLd();
[color_params] = get_default_parameters_color_NCZLd();
%[dynamic_params] = get_default_parameters_dynamic_NCZLd();
[resize_params] = get_default_parameters_resize_NCZLd();
[fusion_params] = get_default_parameters_fusion_NCZLd();
[file_params] = get_default_parameters_file_NCZLd();
[compute_params] = get_default_parameters_compute_NCZLd();
[display_params] = get_default_parameters_display_params_NCZLd();
[gaze_params] = get_default_parameters_gaze_NCZLd();
[cortex_params] = get_default_parameters_cortex_NCZLd();



strct=struct('zli_params',zli,'wave_params',wave_params,'csf_params',csf_params,'color_params',color_params,'resize_params',resize_params,'fusion_params',fusion_params,'file_params',file_params,'compute_params',compute_params,'display_params',display_params,'gaze_params',gaze_params,'cortex_params',cortex_params);


end







function [wave_params] = get_default_parameters_wave_NCZLd()


    %wave_params.multires={'a_trous', 'wav', 'wav_contrast', 'curv', 'gabor', 'gabor_HMAX'};
    wave_params.multires='a_trous';
    
    wave_params.n_scales=0; %auto
    
    wave_params.fin_scale_offset=1;
    wave_params.ini_scale=1;
    wave_params.fin_scale = wave_params.ini_scale + wave_params.fin_scale_offset; %auto
    wave_params.n_orient=0; %auto

    wave_params.mida_min=32; wave_params.nmida_min = num2str(wave_params.mida_min);


end

function [csf_params] = get_default_parameters_csf_NCZLd()
    %csf_params.nu_0 = num2cell(0.5:0.5:6);
    %csf_params.nu_0 ={2.357,4};
    csf_params.nu_0 =4;
    
    
    profile1.params_intensity.fOffsetMax=0.;
    profile1.params_intensity.fContrastMaxMax=1;
    profile1.params_intensity.fContrastMaxMin=0.;
    profile1.params_intensity.fSigmaMax1=1.25;
    profile1.params_intensity.fSigmaMax2=1.25;
    profile1.params_intensity.fContrastMinMax=1.;
    profile1.params_intensity.fContrastMinMin=1.;
    profile1.params_intensity.fSigmaMin1=2;
    profile1.params_intensity.fSigmaMin2=1.;
    profile1.params_intensity.fOffsetMin=2;

    profile1.params_chromatic.fOffsetMax=1;
    profile1.params_chromatic.fContrastMaxMax=2;
    profile1.params_chromatic.fContrastMaxMin=0.;
    profile1.params_chromatic.fSigmaMax1= 2;
    profile1.params_chromatic.fSigmaMax2=1.25;
    profile1.params_chromatic.fContrastMinMax=1.;
    profile1.params_chromatic.fContrastMinMin=1.;
    profile1.params_chromatic.fSigmaMin1=2;
    profile1.params_chromatic.fSigmaMin2=2;
    profile1.params_chromatic.fOffsetMin=2;
    
    
    
    profile2.params_intensity.fOffsetMax=0.;
    profile2.params_intensity.fContrastMaxMax=4.981624;
    profile2.params_intensity.fContrastMaxMin=0.;
    profile2.params_intensity.fSigmaMax1=1.021035;
    profile2.params_intensity.fSigmaMax2=1.048155;
    profile2.params_intensity.fContrastMinMax=1.;
    profile2.params_intensity.fContrastMinMin=1.;
    profile2.params_intensity.fSigmaMin1=0.212226;
    profile2.params_intensity.fSigmaMin2=2.;
    profile2.params_intensity.fOffsetMin=0.530974;
    
    profile2.params_chromatic.fOffsetMax=0.724440;
    profile2.params_chromatic.fContrastMaxMax=3.611746;
    profile2.params_chromatic.fContrastMaxMin=0.;
    profile2.params_chromatic.fSigmaMax1= 1.360638;
    profile2.params_chromatic.fSigmaMax2=0.796124;
    profile2.params_chromatic.fContrastMinMax=1.;
    profile2.params_chromatic.fContrastMinMin=1.;
    profile2.params_chromatic.fSigmaMin1=0.348766;
    profile2.params_chromatic.fSigmaMin2=0.348766;
    profile2.params_chromatic.fOffsetMin=1.059210;
    
    
    %csf_params.params_intensity = {profile1.params_intensity, profile2.params_intensity};
    %csf_params.params_chromatic = {profile1.params_chromatic, profile2.params_chromatic};

    csf_params.params_intensity = profile2.params_intensity;
    csf_params.params_chromatic = profile2.params_chromatic;
    
    
    
end


function [color_params] = get_default_parameters_color_NCZLd()
    color_params.gamma=2.4;
    %color_params.srgb_flag = {-1,0,1};                      % -1 = rgb, 0= opponents without gamma correction. 1= opponents with gamma correction
    color_params.srgb_flag = 1;  
    
    %color_params.HDR={0}; % high dynamic range
    %color_params.orgb_flag= {1,0};
    color_params.orgb_flag= 0;


end


function [dynamic_params] = get_default_parameters_dynamic_NCZLd()

        %dynamic_params.stim=3; 
        %dynamic_params.dynamic=0;
end

function [resize_params] = get_default_parameters_resize_NCZLd() 
    %resize_params.autoresize_ds = {-1,0,1,2,3,4}; %-1 = resize to get < 1024, 0 = not resize, > 0 = 2^ds
    resize_params.autoresize_ds = 0;
    %resize_params.updown={[1],[1,2]};
    %resize_params.updown=[1];
    %resize_params.autoresize_nd = {0,10}; %proportion between image size and window size
    resize_params.autoresize_nd = 0;
    resize_params.M = 0; %auto
    resize_params.N = 0; %auto
end

function [fusion_params] = get_default_parameters_fusion_NCZLd() 
        %fusion_params.output_from_model={'M&w','M'};
     fusion_params.output_from_model='M';
    
    %fusion_params.output_from_csf= {'iFactor','eCSF'};
    fusion_params.output_from_csf= 'iFactor';
    
    %fusion_params.residual_wave= {0,1,2};
    fusion_params.residual_wave= 0;

    %fusion_params.smethod= {'sqmean','pmax','pmaxc','pmax2','wta'};
    fusion_params.smethod= 'pmax2';

    %fusion_params.fusion= {1,2,3,4,5,6};
    fusion_params.fusion= 6;

    %fusion_params.tmem_res = {'mean','max'}; %temporal mean of iFactor or temporal max?
    fusion_params.tmem_res = 'mean'; 
end

function [file_params] = get_default_parameters_file_NCZLd()

    file_params.name = 'image';
    
        % Directory to work
    file_params.outputstr = 'output/';
    file_params.outputstr_imgs = ''; 
    file_params.outputstr_figs = 'figs';
    file_params.outputstr_mats = 'mats';
    file_params.inputstr = 'input/';
    file_params.dir={'/home/cic/xcerda/Neurodinamic','/home/cic/xcerda/Neurodinamic/stimuli'};

    %file_params.delete_mats= {0,1};
    file_params.delete_mats= 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Z.Li's model parameters %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zli_params] = get_default_parameters_zli_NCZLd()

    zli_params.n_membr=10;
    zli_params.n_iter=10;
    zli_params.prec = 0.1;
    
    %zli_params.n_frames.promig=num2cell(1:1:10);
    zli_params.n_frames_promig=10;
    %zli_params.n_frames_promig={10};
    
    %zli_params.dist_type={'eucl', 'manh'}; 
    zli_params.dist_type='eucl';

    zli_params.scalesize_type=-1;
    zli_params.scale2size_type=1;
    zli_params.scale2size_epsilon = 1.3; zli_params.nepsilon=num2str(zli_params.scale2size_epsilon);
    
    %zli_params.bScaleDelta=0,1;
    zli_params.bScaleDelta=1;
    
    %zli_params.reduccio_JW=num2cell(0:0.25:4);
    zli_params.reduccio_JW=1;

    %zli_params.normal_type={'all', 'scale', 'absolute'}; zli_params.normal_min_absolute=0; zli_params.normal_max_absolute=255;
    zli_params.normal_type='scale';
       

    %zli_params.alphax={1.0, 1.35, 1.6, 2.0};
    %zli_params.alphay={1.0, 1.35, 1.6, 2.0};
    zli_params.alphax=1.0;
    zli_params.alphay=1.0;
    
    %zli_params.nb_periods=num2cell(1:1:10);
    zli_params.nb_periods=5;
    zli_params.osc_wv=zli_params.nb_periods*(2*pi/zli_params.n_membr);

    %zli_params.normal_input=num2cell(0:0.5:5);
    %zli_params.normal_output=num2cell(0:0.5:5);
    zli_params.normal_input=2;
    zli_params.normal_output=2.0;	
    zli_params.nnormal_output=num2str(zli_params.normal_output);
    zli_params.normal_min_absolute=0; 
    zli_params.normal_max_absolute=0.25;

    %zli_params.Delta={5, 10, 15, 20, 30, 50, 100};
    zli_params.Delta=15;

    %zli_params.ON_OFF={0, 1, 2};
    zli_params.ON_OFF=0;

    %zli_params.boundary={'mirror', 'wrap'};
    zli_params.boundary='mirror';

    
    zli_params.normalization_power=2;

    %zli_params.kappax={1.0, 1.35, 1.6, 2.0}; %exc
    %zli_params.kappay={1.0, 1.35, 1.6, 2.0}; %inh
    zli_params.kappax=1.0;
    zli_params.kappay=1.35; zli_params.nkappay=num2str(zli_params.kappay); 

    %zli_params.dedi=set_parameters_v2(2000, multires); % OP improve set_parameters
                                                % was (0,multires) for all the
                                                % experiments until 1 2 12
    %zli_params.dedi(1,:)=3*3*ones(1,9);
    %zli_params.dedi(2,:)=0*3*3*ones(1,9);
    zli_params.dedi = [3*3*ones(1,9); 0*3*3*ones(1,9)];
    
    %zli_params.shift={0, 1};
    zli_params.shift=1;



    %zli_params.scale_interaction={0, 1};
    %zli_params.orient_interaction={0, 1};
    zli_params.scale_interaction=1;
    zli_params.orient_interaction=1;
		
    
    
   

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% computational setting %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [compute_params] = get_default_parameters_compute_NCZLd()

    compute_params.model = 1; %matlab
    % Jobmanager
    compute_params.jobmanager='xcerda-10'; % 'penacchio'/'xotazu'/'xcerda'/'xcerda-10'

    % Use MATLAB workers (0:no, 1:yes)
    compute_params.parallel=0;
    compute_params.parallel_channel=0;
    compute_params.parallel_scale=0;
    compute_params.parallel_ON_OFF=0;
    compute_params.parallel_orient=0;

    %compute_params.multiparameters={0};

    % complexity of the set of parameters you want to study 
%     if compute_params.multiparameters1==0
%         compute_params.Nparam=1;
%     else    
%         compute_params.Nparam=size(zli_params.dedi,3);
%     end


    compute_params.use_fft=1;
    compute_params.avoid_circshift_fft=1;

    compute_params.XOP_activacio_neurona=0; % impose activity to a given unit



    %%%%%model output, ecsf

    
    

    
    


end


function [cortex_params] = get_default_parameters_cortex_NCZLd()

        cortex_params.cm_method = 'schwartz_monopole';
        cortex_params.cortex_width = 128;
        cortex_params.a=degtorad(0.77);
        cortex_params.b=degtorad(150);
        cortex_params.lambda=18;
        cortex_params.isoPolarGrad=0.1821;
        cortex_params.eccWidth=0.7609;
        cortex_params.cortex_max_elong_mm = 120;
        cortex_params.cortex_max_az_mm = 60;
        cortex_params.mirroring = 1;
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  stimulus (image, name...) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gaze_params] = get_default_parameters_gaze_NCZLd()


    


        gaze_params.orig_width = 0; %unknown on undistort
        gaze_params.orig_height = 0; %unknown on undistort
        gaze_params.fov_x = 0;
        gaze_params.fov_y = 0;
        gaze_params.img_diag_angle = degtorad(35.12);


    %gaze_params.foveate = {0,1};
    gaze_params.foveate = 1;
    %gaze_params.fov_type = {'cortical', 'gaussian', 'fisheye'};
    gaze_params.fov_type = 'cortical';
 

    gaze_params.redistort_periter = 1;

    gaze_params.ngazes = 1;
    gaze_params.gaze_idx = 0;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% display plot/store    %%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [display_params] = get_default_parameters_display_params_NCZLd()

    display_params.plot_io=0;  % plot input/output (default 1)
    display_params.reduce=0;   % 0 all (9)/ 1 reduced (useless if single_or_multiple=1) (default 0)
    display_params.plot_wavelet_planes=0;  % display wavelet coefficients (default 0)
    display_params.store_img_img_out=1;   % 0 don't save/ 1 save img and img_out
    
    display_params.store=1;    % 0 don't store/ 1 iFactor, c (residual) and Ls (from decomp) and struct [default= 1]
    display_params.store_irrelevant=0;    % 0 don't store irrelevant/ 1 store irrelevant params (J, W...)... (default= 1)
    display_params.savefigs=0;  % save figures for stored values for iFactor, omega ...
    
    
    display_params.XOP_DEBUG=0; % debug (display control values)
    display_params.scale_interaction_debug=0;  % debug (display scale interaction information)
    
    % White effect
    % display_params.y_video=128/256;
    % display_params.x_video=92/256;
    %display_params.y_video=0.5;
    %display_params.x_video=68/128;
    % dynamical case
    display_params.y_video={65/128}; % (default 0.5)
    display_params.x_video={65/128}; % (default 68/128)

   



end







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% wavelets' parameters %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [wave] = get_default_parameters_wave_NCZLd()


    % decomposition choice

    wave_params.multires='a_trous';
    %wave_params.multires='wav';
    %wave_params.multires='wav_contrast';
     %wave_params.multires='curv';
    %wave_params.multires='gabor';
    %wave_params.multires='gabor_HMAX';

    % number of scales (if 0: code calculates it automatically)

    wave_params.n_scales=0;	%auto 
    % wave_params.n_scales=5;
    % wave_params.n_scales=4; 
    wave_params.fin_scale_offset=1;					% last plane to process will be n_scales - fin_scale (and its size will be wave_params.mida_min),
                                                    % i.e. if =0 then residual will be processed (and its size will be wave_params.mida_min)
    wave_params.ini_scale=1;							% Initial scale to process: scale=1 is the highest frequency plane
    wave_params.fin_scale = wave_params.ini_scale + wave_params.fin_scale_offset; %auto
    wave_params.n_orient=0; %auto

    % size of the last wavelet plane to process
    % (see below zli_params.fin_scale_offset parameter in order to include or not residual plane)
    wave_params.mida_min=32; wave_params.nmida_min = num2str(wave_params.mida_min);

   



end

function [csf_params] = get_default_parameters_csf_NCZLd()
    csf_params.nu_0 =4;		% central visual frequency (maximum of the CSF) (default = 3 or 4) %last used= 2.357
    
    csf_params.profile = 'exemple';
    %csf_params.profile = 'Xavier';

    %profile1    
    params_xavi_intensity.fOffsetMax=0.;
    params_xavi_intensity.fContrastMaxMax=1;
    params_xavi_intensity.fContrastMaxMin=0.;
    params_xavi_intensity.fSigmaMax1=1.25;
    params_xavi_intensity.fSigmaMax2=1.25;
    params_xavi_intensity.fContrastMinMax=1.;
    params_xavi_intensity.fContrastMinMin=1.;
    params_xavi_intensity.fSigmaMin1=2;
    params_xavi_intensity.fSigmaMin2=1.;
    params_xavi_intensity.fOffsetMin=2;

    params_xavi_chromatic.fOffsetMax=1;
    params_xavi_chromatic.fContrastMaxMax=2;
    params_xavi_chromatic.fContrastMaxMin=0.;
    params_xavi_chromatic.fSigmaMax1= 2;
    params_xavi_chromatic.fSigmaMax2=1.25;
    params_xavi_chromatic.fContrastMinMax=1.;
    params_xavi_chromatic.fContrastMinMin=1.;
    params_xavi_chromatic.fSigmaMin1=2;
    params_xavi_chromatic.fSigmaMin2=2;
    params_xavi_chromatic.fOffsetMin=2;

    %profile2
    params_naila_intensity.fOffsetMax=0.;
    params_naila_intensity.fContrastMaxMax=4.981624;
    params_naila_intensity.fContrastMaxMin=0.;
    params_naila_intensity.fSigmaMax1=1.021035;
    params_naila_intensity.fSigmaMax2=1.048155;
    params_naila_intensity.fContrastMinMax=1.;
    params_naila_intensity.fContrastMinMin=1.;
    params_naila_intensity.fSigmaMin1=0.212226;
    params_naila_intensity.fSigmaMin2=2.;
    params_naila_intensity.fOffsetMin=0.530974;
    
    params_naila_chromatic.fOffsetMax=0.724440;
    params_naila_chromatic.fContrastMaxMax=3.611746;
    params_naila_chromatic.fContrastMaxMin=0.;
    params_naila_chromatic.fSigmaMax1= 1.360638;
    params_naila_chromatic.fSigmaMax2=0.796124;
    params_naila_chromatic.fContrastMinMax=1.;
    params_naila_chromatic.fContrastMinMin=1.;
    params_naila_chromatic.fSigmaMin1=0.348766;
    params_naila_chromatic.fSigmaMin2=0.348766;
    params_naila_chromatic.fOffsetMin=1.059210;

    if strcmp(csf_params.profile,'Xavier')
        params_intensity = params_xavi_intensity;
	    params_chromatic = params_xavi_chromatic;
    else
        params_intensity = params_naila_intensity;
	    params_chromatic = params_naila_chromatic;

    end
    
    csf_params.params_intensity = params_intensity;
    csf_params.params_chromatic = params_chromatic;
    
    
    % wave_params.csf_params = 'exemple';
    %wave_params.csf_params = 'Xavier';
    % zli_params.nu_0 =4;		% central visual frequency (maximum of the CSF) (default = 3 or 4) %last used= 2.357

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Z.Li's model parameters %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zli_params] = get_default_parameters_zli_NCZLd()

    % differential equation. The total number of iterations are niter/prec
    zli_params.n_membr=10;							% number of membrane time constant; was 15 (default 10).
    zli_params.n_iter=10;								% number of iterations. In the case of a dynamical stimulus, it is the number of frames; integration steps in the Euler integration scheme; (default 10).
    zli_params.prec = 0.1;
    
    % zli_params.n_frames_promig=min(zli_params.niter,4);
    zli_params.n_frames_promig=zli_params.n_membr-1;		% The number of last iterations used to calculate the result (by a mean)
    
    % zli_params.total_iter=zli_params.n_iter/zli_params.prec;

    % distance for I_norm (default eucl)
    zli_params.dist_type='eucl'; 
    % zli_params.dist_type='manh';

    zli_params.scalesize_type=-1;
    zli_params.scale2size_type=1;
    zli_params.scale2size_epsilon = 1.3; zli_params.nepsilon=num2str(zli_params.scale2size_epsilon);
    zli_params.bScaleDelta=true;
    zli_params.reduccio_JW=1; % reduce J and W (default 1)

    %type of normalization
    zli_params.normal_type='scale';
    % zli_params.normal_type='all';
    % zli_params.normal_type='absolute'; zli_params.normal_min_absolute=0; zli_params.normal_max_absolute=255;

    

    % decay in the e/i recurrent equations (default 1.0 each)
    zli_params.alphax=1.0; % 1.6 !!!
    zli_params.alphay=1.0; % 1.6 !!!
    % zli_params.alphax=1.6; % 1.6 !!!
    % zli_params.alphay=1.6; % 1.6 !!!
    % zli_params.alphax=0.1; % 1.6 !!!
    % zli_params.alphay=0.1; % 1.6 !!!




    % period/wavelength oscillation of the dynamical stimulus
    zli_params.nb_periods=5;  % was 3
    zli_params.osc_wv=zli_params.nb_periods*(2*pi/zli_params.n_membr);

    % normalization
    zli_params.normal_input=2;	% Rescaled maximum value of input data for Z.Li method %default is 4
    zli_params.normal_output=2.0;	zli_params.nnormal_output=num2str(zli_params.normal_output);	% Rescaled maximum value of output data for Z.Li method
    zli_params.normal_min_absolute=0; 
    zli_params.normal_max_absolute=0.25;

    zli_params.Delta=15;								% maximum radius of the area of influence

    zli_params.ON_OFF=0;	% 0: separate, 1: abs, 2:square

    zli_params.boundary='mirror';  % or 'wrap'

    zli_params.normalization_power=2; % power of the denominator in the normalization step

    % multiplicative factor (default 1.0)
    % zli_params.kappa1=1.0*ones(1,10);				% e (excitation)
    % zli_params.kappa2=1.0*ones(1,10);				% i (inhibition)
    zli_params.kappax=1.0; % 1.6 !!!
    zli_params.kappay=1.35; zli_params.nkappay=num2str(zli_params.kappay); % 1.6 !!! %1.0 %1.35  %2.0



    % psychophysical optimization
    zli_params.dedi(1,:)=3*3*ones(1,9);
    zli_params.dedi(2,:)=0*3*3*ones(1,9);
    %zli_params.dedi=set_parameters_v2(2000, multires); % OP improve set_parameters
                                                % was (0,multires) for all the
                                                % experiments until 1 2 12

    zli_params.shift=1;								% Minimum value of input data for Z.Li method



    zli_params.scale_interaction=1; %yes,no
    zli_params.orient_interaction=1; %yes,no
		
    
    
   

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% computational setting %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [compute] = get_default_parameters_compute_NCZLd()

    % Directory to work
    file_params.outputstr = 'output/'; %fullfile(pwd,'.','output');
    file_params.outputstr_imgs = [file_params.outputstr 'output_imgs']; %fullfile(pwd,'.','output');
    file_params.outputstr_figs = [file_params.outputstr 'output_figs']; %fullfile(pwd,'.','output');
    file_params.outputstr_mats = [file_params.outputstr 'output_mats']; %fullfile(pwd,'.','output');
    file_params.inputstr = 'input/'; %fullfile(pwd,'.','input');
    file_params.dir={'/home/cic/xcerda/Neurodinamic','/home/cic/xcerda/Neurodinamic/stimuli'};
    % Jobmanager
    compute_params.jobmanager='xcerda-10'; % 'penacchio'/'xotazu'/'xcerda'/'xcerda-10'

    % Use MATLAB workers (0:no, 1:yes)
    compute_params.parallel=0;						% Concurrent for every image
    compute_params.parallel_channel=0;			% Concurrent for every channel (i.e. intensity and 2 chromatic)
    compute_params.parallel_scale=0;				% Concurrent for every wavelet plane 
    compute_params.parallel_ON_OFF=0;				% Concurrent for every wavelet plane 
    compute_params.parallel_orient=0;				% Concurrent for every wavelet orientation 
    %dynamic_params.dynamic=0;						% 0 stable/1 dynamic stimulus
%     compute_params.multiparameters=0;				% 0 for the first parameter of the list/ 1 for all the parameters

    % complexity of the set of parameters you want to study 
%     if compute_params.multiparameters==0
%         compute_params.Nparam=1;
%     else    
%         compute_params.Nparam=size(zli_params.dedi,3);
%     end


    compute_params.use_fft=1;
    compute_params.avoid_circshift_fft=1;

    display_params.XOP_DEBUG=0; % debug (display control values)
    display_params.scale_interaction_debug=0;  % debug (display scale interaction information)
    compute_params.XOP_activacio_neurona=0; % impose activity to a given unit


    %color_params.HDR=0; % high dynamic range

    %%%%%model output, ecsf

    % compute_params.output_type='image';
    % compute_params.output_type='saliency';

    %fusion_params.output_from_csf= 'model';
    fusion_params.output_from_csf= 'eCSF';
    %fusion_params.output_from_csf= 'model&eCSF'; %iFactor.*eCSF

    fusion_params.residual_wave= 0; % 0=sense residu
    %fusion_params.residual_wave= 1; % 1=amb residu 0 + 1
    %fusion_params.residual_wave= 2; % 1=amb residu


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  stimulus (image, name...) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [image] = get_default_parameters_image_NCZLd()


    



    color_params.gamma=2.4;							% gamma correction
    color_params.srgb_flag = 1;                        % -1 = rgb, 0= opponents without gamma correction. 1= opponents with gamma correction
    %resize_params.updown=[1];							% up/downsample ([1,2])

    % dynamic_params.stim dynamic case only; # correspond to figures in Rossi & Paradiso,
    % J.Neurosciences, 1999
    %dynamic_params.stim=3; % (this doesn't appear in the default parameters)
    
     fusion_params.output_from_model='M'; %iFactor
    %fusion_params.output_from_model='M&w'; %iFactor.*curv


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% display plot/store    %%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [display_params] = get_default_parameters_display_params_NCZLd()

    display_params.plot_io=0;  % plot input/output (default 1)
    display_params.reduce=0;   % 0 all (9)/ 1 reduced (useless if single_or_multiple=1) (default 0)
    display_params.plot_wavelet_planes=0;  % display wavelet coefficients (default 0)
    display_params.store_img_img_out=1;   % 0 don't save/ 1 save img and img_out
    
    display_params.store=1;    % 0 don't store/ 1 iFactor, c (residual) and Ls (from decomp) and struct [default= 1]
    display_params.store_irrelevant=0;    % 0 don't store irrelevant/ 1 store irrelevant params (J, W...)... (default= 1)
    display_params.savefigs=0;  % save figures for stored values for iFactor, omega ...
    
    
    
    % White effect
    % display_params.y_video=128/256;
    % display_params.x_video=92/256;
    %display_params.y_video=0.5;
    %display_params.x_video=68/128;
    % dynamical case
    display_params.y_video=65/128; % (default 0.5)
    display_params.x_video=65/128; % (default 68/128)

   



end


