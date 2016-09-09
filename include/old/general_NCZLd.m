function [img,img_out]=general_NCZLd(image_name,mida_min,epsilon,kappay,normal_output)
% new OP
addpath(strcat(pwd,'\','stimuli'));



% NCZL main file


%--------------------------------------------------------------------
% build the structure
clear struct wave zli display_plot compute 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Default parameters %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

strct=get_default_parameters_NCZLd();

% Prepare structures 
zli_params=strct.zli_params;
wave=strct.wave;
image=strct.image;
display=strct.display;
compute=strct.compute;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% The following parameters overwrite the previous ones %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters for the last experiments
if nargin==0
    % min frequency processed
    wave.mida_min=32;  % was 32
    % old dedi revisited
    zli.scale2size_type=-1;   % epsilon=1 gives 2.^(s-1)
    % epsilon=0.5 gives 1.^(s)
    zli.scale2size_epsilon=1.3;  % was 1.1
    % kappa y
    zli.kappay=1.35; % was 1.25 % was 2 !!!
    % rescaled maximum value of output data for Z.Li method
    zli.normal_output=2;  % was 1.5
    % prepare the name
    nmida_min=num2str(wave.mida_min);
    nepsilon=num2str( zli.scale2size_epsilon);
    nkappay=num2str(zli.kappay);
    nnormal_output=num2str(zli.normal_output);
else
    % name of the stimulus
    image.single_or_multiple=1;
    image.single=image_name;
    % min frequency processed
    wave.mida_min=mida_min;  % was 32
    % old dedi revisited
    zli.scale2size_type=-1; % (-1) uses epsilon as a parameter ( (2*epsilon).^s )
    % (0) stands for 2.^(s-1)
    % (1) stands for 2.^(s)
    % (2) stands for
    zli.scale2size_epsilon=epsilon;
    % kappa y
    zli.kappay=kappay; % was 2 !!!
    % rescaled maximum value of output data for Z.Li method
    zli.normal_output=normal_output;
    % prepare the name
    nmida_min=num2str(mida_min);
    nepsilon=num2str(epsilon);
    nkappay=num2str(kappay);
    nnormal_output=num2str(normal_output);
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%% wavelets' parameters %%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% choice for a wavelet decomposition
wave.multires='a_trous'; 
%wave.multires='gabor_HMAX'; 
if strcmp(wave.multires,'gabor_HMAX')
     zli.scale2size_type=-2;  % new gop14
end

zli.normal_min_absolute=0; zli.normal_max_absolute=0.25;
% wave.multires='a_trous_contrast'; zli.normal_min_absolute=0; zli.normal_max_absolute=0.1;
% wave.multires='wav';
% wave.multires='wav_contrast';
% % wave.multires='curv';
% %wave.multires='gabor';
% wave.multires='gabor_HMAX';
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%% Z.Li's model parameters %%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters for the differential equation
zli.n_membr=20;  % number of membrane time constant; was 15
zli.n_iter=10;   % integration steps in the Euler integration scheme; was 10

% distance for I_norm
zli.dist_type='eucl';
% zli.dist_type='manh';

% type of normalization
% zli.normal_type='scale';
zli.normal_type='all';
% zli.normal_type='absolute';

% reduce J and W
zli.reduccio_JW=1;

% zli.total_iter=zli.n_iter/zli.prec;

% decay in the e/i recurrent equations
zli.alphax=1.0; % 1.6 !!!
zli.alphay=1.0; % 1.6 !!!

% multiplicative factor
zli.kappax=1.0; %  !!!




% period/wavelength oscillation of the dynamical stimulus (dynamical case only)
Hz=2;
zli.nb_periods=zli.n_membr/100*Hz;  % was 3
zli.osc_wv=zli.nb_periods*(2*pi/zli.n_membr);

% boundary conditions 
% zli.boundary='mirror';  % or 'wrap'

% power of the denominator in the normalization step 
zli.normalization_power=2; 

% psychophysical optimization
% 0=[15.513625 15.830895 29.938804 18.818254 28.655948 29.889573 29.459179 22.086692 10.874822 4.657473]
% zli.kappa1(1:10)=1.55*ones(1,10);
% zli.kappa2(1:10)=1.58*ones(1,10);
zli.dedi(1,:)=3*3*ones(1,9);
zli.dedi(2,:)=0*3*3*ones(1,9);

 
%zli.normal_output=2.0;		% Rescaled maximum value of output data for Li's method
% scale interaction yes/no
zli.scale_interaction=1;
% orientation interaction yes/no
zli.orient_interaction=0;
% 0: ON and OFF are separated; 1: absolute value; 2: quadratic
zli.ON_OFF=0;								
% minimum value of input data for Li's method
zli.shift=1;	
% rescaled maximum value of input data for Z.Li method
zli.normal_input=4;						

														  
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%% computational setting %%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

compute.dynamic=0; % 0 stable/1 dynamic stimulus
compute.parallel_scale=0; 
compute.parallel_ON_OFF=0; 
compute.jobmanager='xotazu';  % 'penacchio'/'xotazu'
% compute.multiparameters=0; % 0 for the first parameter of the list/ 1 for all the parameters

% use fft for speed
compute.use_fft=1;
% avoid circshift for speed
compute.avoid_circshift_fft=1;
% debug (display control values)
compute.XOP_DEBUG=0;
% debug (display scale interaction information)
compute.scale_interaction_debug=0;
% impose activity to a given unit
compute.XOP_activacio_neurona=0;
% high dynamic range
compute.HDR=0;
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%  stimulus (image, name...) %%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dynamic case only; # correspond to figures in Rossi & Paradiso,
% J.Neurosciences, 1999
image.stim=3; 

% select the input image (static case)
if nargin==0
    image.single_or_multiple=1; % 1 for single, 2 for multiple
    image.single='grating10';  % high frequency grating
    image.single='natural128';  % a first example of natural images
    image.single='branches128';  % branches high energy (like a grating)
    % image.single='SBC1_256'; % useless if single_or_multiple=2
    % image.single='SBC3_256'; % useless if single_or_multiple=2
    % image.single='mach_64'; % useless if single_or_multiple=2
    % image.single='mach'; % useless if single_or_multiple=2
    % image.single='mach_256'; % useless if single_or_multiple=2
    % image.single='che'; % useless if single_or_multiple=2
    % image.single='che_256'; % note: same as 'che', is 240x400 instead of
    % 256x256
    % image.single='che_128'; % useless if single_or_multiple=2
    % image.single='whi'; % useless if single_or_multiple=2
    % image.single='whi_256'; % same as 'whi'
    % image.single='whi_512'; % useless if single_or_multiple=2
    %  image.single='whi_1024'; % useless if single_or_multiple=2
    % image.single='whi_128'; % useless if single_or_multiple=2
    % image.single='whi_64'; % useless if single_or_multiple=2
    % image.single='todo'; % useless if single_or_multiple=2
    %  image.single='todo_512'; % useless if single_or_multiple=2
    % image.single='todo_256'; % useless if single_or_multiple=2
    % image.single='todo_128'; % useless if single_or_multiple=2
    % image.single='grating';
    % image.single='grating_128';
    % image.single='grating_256';
    % image.single='nat1_256';
    % image.single='nat1_512';
    % image.single='lena_256';
    % image.single='lena_512';
    %image.single='lena_512';
    %image.single='orientat_256';
    %image.single='orientat_ortog_256';
    % image.single='orientat_diag_256';
    % image.single='demo'; % useless if single_or_multiple=2
    % image.single='memorial';
    % image.single='memorial_128';
    % image.single='Assim_Verd_blau';
    % image.single='Contrast_Yellow_Green_256';
    % %  image.single='whi_swirl_petit'; % useless if single_or_multiple=2
    % %  image.single='whi_swirl'; % useless if single_or_multiple=2
    image.multiple={'mach','che','whi'}; % useless if single_or_multiple=1
    % % image.multiple={'whi','whi_new25','whi_new50'}; % useless if single_or_multiple=1
    % % list of shortnames:
    % %
    % %
    % %
    % %
    % %
    %
    % image.gamma=2.4; % gamma correction
    % image.updown=[1]; % up/downsample ([1,2])
    image_name=image.single
end

% static case
if compute.dynamic==0 
	image.n_frames_promig=zli.n_membr-1; % number of final iterations used to calculate the result (mean value)
	if image.single_or_multiple==1 % only one stimulus
		[tmp,name]=get_the_stimulus(image.single);
		image.tmp=tmp;
%         if nargin==0
%             image.name=name;
%             
%         end
	elseif image.single_or_multiple==2 % three stimuli
		[tmp1,name1,tmp2,name2,tmp3,name3]=get_the_stimuli(image.multiple);
	end
end 

% new (9.14.12): name of the output (and main parameters made explicit in the name)
image.name=strcat(image_name,'_min_freq_',nmida_min,'_epsilon_',nepsilon,...
                             '_kappay_',nkappay,'_normal_output_',nnormal_output);
% image.name = strrep(image.name, '.', '_');                         

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% display plot/store    %%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

display_plot.plot_io=0;  % plot input/output
display_plot.reduce=0;   % 0 all (9)/ 1 reduced (useless if single_or_multiple=1)
display_plot.plot_wavelet_planes=0;  % display wavelet coefficients
display_plot.store=1;    % 0 don't store/ 1 store curv, iFactor and more...
if compute.dynamic==1
    display_plot.store=1;      % always store in the dynamical case
end    
display_plot.store_img_img_out=1;   % 0/1 don't save/save img and img_out

% White effect
% display_plot.y_video=128/256;
% display_plot.x_video=92/256;

% dynamical case
display_plot.y_video=65/128;
display_plot.x_video=65/128;

%--------------------------------------------------------------------
% complexity of the set of parameters you want to study (not included
% in the structure but as free variables)
if compute.multiparameters==0
    Nparam=1;
else    
    Nparam=size(zli.dedi,3);
end
%--------------------------------------------------------------------

% input frames in the dynamical case
if compute.dynamic==1
    flanksd=20; % distance between the flanks (5=one receptive field); was 12
%     tmpa=imread('ima.ppm');
%     tmpb=imread('imb.ppm');
[tmpa,tmpb]=get_the_stimulusd(128,flanksd,image.stim);
	image.name=['dynamic' int2str(image.stim) '_' int2str(zli.n_membr)...
        '_' int2str(zli.n_iter) 'tmembr_' int2str(Hz) 'Hz_flanks_' int2str(flanksd)];
    tmp=zeros(size(tmpa,1),size(tmpa,2),3,zli.n_membr);
    q=cos(zli.osc_wv.*(1:zli.n_membr));
    %pos(q>=0)=1;pos(q<0)=-1;
    % q(abs(q)<0.05 & q>=0)=0.05;
    % q(abs(q)<0.05 & q<0)=-0.05;
    for ff=1:zli.n_membr
        tmp(:,:,:,ff)=uint8(double(tmpa)+q(ff).*double(tmpb));
    end
end

% % verification plot (is the movie what you think it should be?)
%     for ff=1:zli.total_iter
%        figure;imshow(uint8(double(tmpa)+q(ff).*double(tmpb)),[]);
%     end
%--------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%    meta structure     %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strct=struct('zli',zli,'wave',wave,'image',image,'display_plot',display_plot,'compute',compute);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   core of the process -> NCZLd   %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if compute.dynamic==0 % static
            if image.single_or_multiple==1
                for n=1:Nparam;
                    [img,img_out]=NCZLd(tmp,strct);
                    % plot/no plot
                    if display_plot.plot_io==1
                        % get the name
                        str_delta=num2str(zli.Delta);
                        str_n=num2str(n);
                        str_de1=num2str(zli.dedi(1,1,n)); % 1,1,n for excitation, scale 1, nth parameters in the list 
                        str_di1=num2str(zli.dedi(2,1,n)); 
                        str_de2=num2str(zli.dedi(1,2,n)); 
                        str_di2=num2str(zli.dedi(2,2,n)); 
                        str_de3=num2str(zli.dedi(1,3,n)); 
                        str_di3=num2str(zli.dedi(2,3,n)); 
                        %imageoutname=strcat(name,'_',str_delta,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
                        %                        '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
                        
                        % plot
%                        figure('Name',imageoutname)
                            subplot(3,1,1),imshow(uint8(img));h=title('Visual stimulus');set(h,'FontSize',16);
									 subplot(3,1,2),imshow(uint8(img_out));h=title('Predicted brightness');set(h,'FontSize',16);
                            subplot(3,1,3),plot(img(round((size(img,2)/2)),:,1),'--b');hold on
                            plot(img_out(round((size(img_out,2)/2)),:,1),'r');h=title('Brightness profile');set(h,'FontSize',16);legend('Visual stimulus','Predicted brightness');xlabel('# image column');ylabel('Brightness (arbitrary units)');
									 hold off;
                    end
                end
            elseif image.single_or_multiple==2
                for n=1:Nparam;
                        [img1,img_out1]=NCZLd(tmp1,strct);
                        [img2,img_out2]=NCZLd(tmp2,strct);
                        [img3,img_out3]=NCZLd(tmp3,strct);
                        % plot/no plot
                        if display_plot.plot_io==1
                            % get the name
                            str_delta=num2str(zli.Delta);
                            str_n=num2str(n);
                            str_de1=num2str(zli.dedi(1,1,n)); % 1,1,n for excitation, scale 1, nth parameters in the list 
                            str_di1=num2str(zli.dedi(2,1,n)); 
                            str_de2=num2str(zli.dedi(1,2,n)); 
                            str_di2=num2str(zli.dedi(2,2,n)); 
                            str_de3=num2str(zli.dedi(1,3,n)); 
                            str_di3=num2str(zli.dedi(2,3,n)); 
                            imageoutname=strcat(name1,'_',name2,'_',name3,'_',str_delta,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
                                                    '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
                            imageoutname1=strcat(name1,'_',str_delta,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
                                                    '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
                            imageoutname2=strcat(name2,'_',str_delta,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
                                                    '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
                            imageoutname3=strcat(name3,'_',str_delta,'_',str_n,'sc1','_',str_de1,'_',str_di1,...
                                                    '_','sc2','_',str_de2,'_',str_di2,'_','sc3','_',str_de3,'_',str_di3);
                            % plot
                                % all (9x9: plot the three images/induced images/brightness profiles)
                                if display_plot.reduce==0
                                    figure('Name',imageoutname)
                                        subplot(3,3,1),imshow(uint8(img1));colormap('gray');
                                        subplot(3,3,2),imshow(uint8(img_out1));colormap('gray');
                                        subplot(3,3,3),plot(img1(round((size(img1,2)/2)),:,1),'--b');hold on
                                        plot(img_out1(round((size(img_out1,2)/2)),:,1),'r');
                                        subplot(3,3,4),imshow(uint8(img2));colormap('gray');
                                        subplot(3,3,5),imshow(uint8(img_out2));colormap('gray');
                                        subplot(3,3,6),plot(img2(round((size(img2,2)/2)),:,1),'--b');hold on
                                        plot(img_out2(round((size(img_out2,2)/2)),:,1),'r');
                                        subplot(3,3,7),imshow(uint8(img3));colormap('gray');
                                        subplot(3,3,8),imshow(uint8(img_out3));colormap('gray');
                                        subplot(3,3,9),plot(img3(round((size(img3,2)/2)),:,1),'--b');hold on
                                        plot(img_out3(round((size(img_out3,2)/2)),:,1),'r');
                                % reduced (only brightness profiles)
                                elseif display_plot.reduce==1
                                    figure('Name',imageoutname)
                                        subplot(3,1,1),plot(img1(round((size(img1,2)/2)),:,1),'--b');hold on
                                        plot(img_out1(round((size(img_out1,2)/2)),:,1),'r');
                                        subplot(3,1,2),plot(img2(round((size(img2,2)/2)),:,1),'--b');hold on
                                        plot(img_out2(round((size(img_out2,2)/2)),:,1),'r');
                                        subplot(3,1,3),plot(img3(round((size(img3,2)/2)),:,1),'--b');hold on
                                        plot(img_out3(round((size(img_out3,2)/2)),:,1),'r');
                                end    
                        end
                        % store/ don't store
                        if display_plot.store==1
                            save(imageoutname1,'img_out1')
                            save(imageoutname2,'img_out2')
                            save(imageoutname3,'img_out3')
                        end    

                end
            end    
elseif compute.dynamic==1 % dynamic
	for n=1:Nparam;
		[img,img_out]=NCZLd(tmp,strct);
% 		if display_plot.store==1
% 			save('img','img')
% 			save('img_out','img_out')
% 		end
		if(display_plot.plot_io==1)
			% rough verification
			%                     for ff=1:zli.total_iter % input
			%                        % figure;imshow(uint8(img(:,:,:,ff)),[]);
			%                     end
			%                     for ff=1:zli.total_iter % output
			%                         figure;imshow(uint8(img_out(:,:,:,ff)),[]);
			%                     end
			cut=zeros(size(img,2),zli.n_membr);
			cut_out=zeros(size(img,2),zli.n_membr);
			for ff=1:zli.n_membr
				cut(:,ff)=img(round((size(img,2)/2)),:,1,ff);
				cut_out(:,ff)=img_out(round((size(img,2)/2)),:,1,ff);
				%figure;plot(cut(:,ff),'--b');hold on
				%    plot(cut_out(:,ff),'r');
			end
			% stimulus oscillation/central cell response
			q=[cut(round((size(img,2)/4)),:);cut_out(round((size(img,2)/2)),:)];	% Surround luminosity
			%                     q=[cut(round((size(img,2)/2)),:);cut_out(round((size(img,2)/2)),:)]; % RF luminosity
			window_size=5;
			h=ones(1,window_size)/window_size;
			w=imfilter(q(2,:),h,'symmetric');
			figure;plot((1:size(q,2)),q(1,:),'b');hold on
			plot((1:size(q,2)),q(2,:),'r');hold on
			plot((1:size(q,2)),w,'g','LineWidth',3)
			grid on;grid minor
			z=1;
		end
	end
	
end
   
