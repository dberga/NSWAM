function [strct]=get_default_parameters_NCZLd()



[wave] = get_default_parameters_wave_NCZLd();
[zli] = get_default_parameters_zli_NCZLd();

    if strcmp(wave.multires,'gabor_HMAX')
         zli.scale2size_type=-2;  % new gop14
    end
    
[compute] = get_default_parameters_compute_NCZLd();
[image] = get_default_parameters_image_NCZLd();
[csfparams] = get_default_parameters_csf_NCZLd();
[display_plot] = get_default_parameters_display_plot_NCZLd();

strct=struct('zli',zli,'wave',wave,'csfparams',csfparams,'image',image,'display_plot',display_plot,'compute',compute);
% strct=struct('zli',zli,'wave',wave,'image',image,'compute',comp);
    

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% wavelets' parameters %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [wave] = get_default_parameters_wave_NCZLd()


    % decomposition choice

    wave.multires='a_trous';
    %wave.multires='wav';
    %wave.multires='wav_contrast';
     %wave.multires='curv';
    %wave.multires='gabor';
    %wave.multires='gabor_HMAX';

    % number of scales (if 0: code calculates it automatically)

    wave.n_scales=0; 
    % wave.n_scales=5;
    % wave.n_scales=4; 
    wave.fin_scale_offset=1;					% last plane to process will be n_scales - fin_scale (and its size will be wave.mida_min),
                                                    % i.e. if =0 then residual will be processed (and its size will be wave.mida_min)
    wave.ini_scale=1;							% Initial scale to process: scale=1 is the highest frequency plane
    wave.fin_scale = wave.ini_scale + wave.fin_scale_offset; %this will be changed on selecting the multires.decomp. on NCZLd
    wave.n_orient=0; 

    % size of the last wavelet plane to process
    % (see below zli.fin_scale_offset parameter in order to include or not residual plane)
    wave.mida_min=32; wave.nmida_min = num2str(wave.mida_min);

   



end

function [csfparams] = get_default_parameters_csf_NCZLd()
    csfparams.nu_0 =4;		% central visual frequency (maximum of the CSF) (default = 3 or 4) %last used= 2.357
    
    csfparams.profile = 'exemple';
    %csfparams.profile = 'Xavier';
    
    
    if strcmp(csfparams.profile,'Xavier')
            params_intensity.fOffsetMax=0.;
            params_intensity.fContrastMaxMax=1;
            params_intensity.fContrastMaxMin=0.;
            params_intensity.fSigmaMax1=1.25;
            params_intensity.fSigmaMax2=1.25;
            params_intensity.fContrastMinMax=1.;
            params_intensity.fContrastMinMin=1.;
            params_intensity.fSigmaMin1=2;
            params_intensity.fSigmaMin2=1.;
            params_intensity.fOffsetMin=2;

            params_chromatic.fOffsetMax=1;
            params_chromatic.fContrastMaxMax=2;
            params_chromatic.fContrastMaxMin=0.;
            params_chromatic.fSigmaMax1= 2;
            params_chromatic.fSigmaMax2=1.25;
            params_chromatic.fContrastMinMax=1.;
            params_chromatic.fContrastMinMin=1.;
            params_chromatic.fSigmaMin1=2;
            params_chromatic.fSigmaMin2=2;
            params_chromatic.fOffsetMin=2;

    else
            params_intensity.fOffsetMax=0.;
            params_intensity.fContrastMaxMax=4.981624;
            params_intensity.fContrastMaxMin=0.;
            params_intensity.fSigmaMax1=1.021035;
            params_intensity.fSigmaMax2=1.048155;
            params_intensity.fContrastMinMax=1.;
            params_intensity.fContrastMinMin=1.;
            params_intensity.fSigmaMin1=0.212226;
            params_intensity.fSigmaMin2=2.;
            params_intensity.fOffsetMin=0.530974;
            
            params_chromatic.fOffsetMax=0.724440;
            params_chromatic.fContrastMaxMax=3.611746;
            params_chromatic.fContrastMaxMin=0.;
            params_chromatic.fSigmaMax1= 1.360638;
            params_chromatic.fSigmaMax2=0.796124;
            params_chromatic.fContrastMinMax=1.;
            params_chromatic.fContrastMinMin=1.;
            params_chromatic.fSigmaMin1=0.348766;
            params_chromatic.fSigmaMin2=0.348766;
            params_chromatic.fOffsetMin=1.059210;

    end
    
    csfparams.params_intensity = params_intensity;
    csfparams.params_chromatic = params_chromatic;
    
    
    % wave.csf_params = 'exemple';
    %wave.csf_params = 'Xavier';
    % zli.nu_0 =4;		% central visual frequency (maximum of the CSF) (default = 3 or 4) %last used= 2.357

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Z.Li's model parameters %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zli] = get_default_parameters_zli_NCZLd()

    % differential equation. The total number of iterations are niter/prec
    zli.n_membr=10;							% number of membrane time constant; was 15 (default 10).
    zli.n_iter=10;								% number of iterations. In the case of a dynamical stimulus, it is the number of frames; integration steps in the Euler integration scheme; (default 10).
    zli.prec = 0.1;
    
    % zli.n_frames_promig=min(zli.niter,4);
    zli.n_frames_promig=zli.n_membr-1;		% The number of last iterations used to calculate the result (by a mean)
    
    % zli.total_iter=zli.n_iter/zli.prec;

    % distance for I_norm (default eucl)
    zli.dist_type='eucl'; 
    % zli.dist_type='manh';

    zli.scalesize_type=-1;
    zli.scale2size_type=1;
    zli.scale2size_epsilon = 1.3; zli.nepsilon=num2str(zli.scale2size_epsilon);
    zli.bScaleDelta=true;
    zli.reduccio_JW=1; % reduce J and W (default 1)

    %type of normalization
    zli.normal_type='scale';
    % zli.normal_type='all';
    % zli.normal_type='absolute'; zli.normal_min_absolute=0; zli.normal_max_absolute=255;

    

    % decay in the e/i recurrent equations (default 1.0 each)
    zli.alphax=1.0; % 1.6 !!!
    zli.alphay=1.0; % 1.6 !!!
    % zli.alphax=1.6; % 1.6 !!!
    % zli.alphay=1.6; % 1.6 !!!
    % zli.alphax=0.1; % 1.6 !!!
    % zli.alphay=0.1; % 1.6 !!!




    % period/wavelength oscillation of the dynamical stimulus
    zli.nb_periods=5;  % was 3
    zli.osc_wv=zli.nb_periods*(2*pi/zli.n_membr);

    % normalization
    zli.normal_input=2;	% Rescaled maximum value of input data for Z.Li method %default is 4
    zli.normal_output=2.0;	zli.nnormal_output=num2str(zli.normal_output);	% Rescaled maximum value of output data for Z.Li method
    zli.normal_min_absolute=0; 
    zli.normal_max_absolute=0.25;

    zli.Delta=15;								% maximum radius of the area of influence

    zli.ON_OFF=0;	% 0: separate, 1: abs, 2:square

    zli.boundary='mirror';  % or 'wrap'

    zli.normalization_power=2; % power of the denominator in the normalization step

    % multiplicative factor (default 1.0)
    % zli.kappa1=1.0*ones(1,10);				% e (excitation)
    % zli.kappa2=1.0*ones(1,10);				% i (inhibition)
    zli.kappax=1.0; % 1.6 !!!
    zli.kappay=1.35; zli.nkappay=num2str(zli.kappay); % 1.6 !!! %1.0 %1.35  %2.0



    % psychophysical optimization
    zli.dedi(1,:)=3*3*ones(1,9);
    zli.dedi(2,:)=0*3*3*ones(1,9);
    %zli.dedi=set_parameters_v2(2000, multires); % OP improve set_parameters
                                                % was (0,multires) for all the
                                                % experiments until 1 2 12

    zli.shift=1;								% Minimum value of input data for Z.Li method



    zli.scale_interaction=1; %yes,no
    zli.orient_interaction=1; %yes,no
		
    
    
   

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% computational setting %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [compute] = get_default_parameters_compute_NCZLd()

    % Directory to work
    compute.outputstr = 'output/'; %fullfile(pwd,'.','output');
    compute.outputstr_imgs = [compute.outputstr 'output_imgs']; %fullfile(pwd,'.','output');
    compute.outputstr_figs = [compute.outputstr 'output_figs']; %fullfile(pwd,'.','output');
    compute.outputstr_mats = [compute.outputstr 'output_mats']; %fullfile(pwd,'.','output');
    compute.inputstr = 'input/'; %fullfile(pwd,'.','input');
    compute.dir={'/home/cic/xcerda/Neurodinamic','/home/cic/xcerda/Neurodinamic/stimuli'};
    % Jobmanager
    compute.jobmanager='xcerda-10'; % 'penacchio'/'xotazu'/'xcerda'/'xcerda-10'

    % Use MATLAB workers (0:no, 1:yes)
    compute.parallel=0;						% Concurrent for every image
    compute.parallel_channel=0;			% Concurrent for every channel (i.e. intensity and 2 chromatic)
    compute.parallel_scale=0;				% Concurrent for every wavelet plane 
    compute.parallel_ON_OFF=0;				% Concurrent for every wavelet plane 
    compute.parallel_orient=0;				% Concurrent for every wavelet orientation 
    compute.dynamic=0;						% 0 stable/1 dynamic stimulus
    compute.multiparameters=0;				% 0 for the first parameter of the list/ 1 for all the parameters

    % complexity of the set of parameters you want to study 
    if compute.multiparameters==0
        compute.Nparam=1;
    else    
        compute.Nparam=size(zli.dedi,3);
    end


    compute.use_fft=1;
    compute.avoid_circshift_fft=1;

    compute.XOP_DEBUG=0; % debug (display control values)
    compute.scale_interaction_debug=0;  % debug (display scale interaction information)
    compute.XOP_activacio_neurona=0; % impose activity to a given unit


    compute.HDR=0; % high dynamic range

    %%%%%model output, ecsf

    % compute.output_type='image';
    % compute.output_type='saliency';

    compute.output_from_model='M';
    %compute.output_from_model='M&w'; %iFactor.*curv

    %compute.output_from_csf= 'model';
    compute.output_from_csf= 'eCSF';
    %compute.output_from_csf= 'model&eCSF'; %iFactor.*eCSF

    compute.output_from_residu= 0; % 0=sense residu
    %compute.output_from_residu= 1; % 1=amb residu


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  stimulus (image, name...) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [image] = get_default_parameters_image_NCZLd()


    


    image.single_or_multiple=1;			% 1 for single, 2 for multiple
    image.single='mach';					% useless if single_or_multiple=2
    % image.single='che';					% useless if single_or_multiple=2
    % image.single='whi';						% useless if single_or_multiple=2
    %  image.single='whi_swirl_petit';	% useless if single_or_multiple=2
    %  image.single='whi_swirl';			% useless if single_or_multiple=2
    % image.multiple={'mach','che','whi'};	% useless if single_or_multiple=1
    % image.multiple={'whi','whi_new25','whi_new50'};	% useless if single_or_multiple=1
    % list of shortnames:
    %
    %
    %
    %
    % 

    image.gamma=2.4;							% gamma correction
    image.srgb_flag = 1;                        % -1 = rgb, 0= opponents without gamma correction. 1= opponents with gamma correction
    image.updown=[1];							% up/downsample ([1,2])

    % image.stim dynamic case only; # correspond to figures in Rossi & Paradiso,
    % J.Neurosciences, 1999
    image.stim=3; % (this doesn't appear in the default parameters)
    image.nstripes = 0;


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% display plot/store    %%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [display_plot] = get_default_parameters_display_plot_NCZLd()

    display_plot.plot_io=0;  % plot input/output (default 1)
    display_plot.reduce=0;   % 0 all (9)/ 1 reduced (useless if single_or_multiple=1) (default 0)
    display_plot.plot_wavelet_planes=0;  % display wavelet coefficients (default 0)
    display_plot.store_img_img_out=1;   % 0 don't save/ 1 save img and img_out
    
    display_plot.store=1;    % 0 don't store/ 1 store curv, iFactor and more... (default 1)
    display_plot.savefigs=1;  % save stored values for iFactor, omega ...
    
    % White effect
    % display_plot.y_video=128/256;
    % display_plot.x_video=92/256;
    %display_plot.y_video=0.5;
    %display_plot.x_video=68/128;
    % dynamical case
    display_plot.y_video=65/128; % (default 0.5)
    display_plot.x_video=65/128; % (default 68/128)

   



end


