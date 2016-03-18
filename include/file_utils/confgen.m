function [  ] = confgen( )


[wave] = get_all_parameters_wave_NCZLd();
[zli] = get_all_parameters_zli_NCZLd();


    if cell2mat(strfind(wave.multires,'gabor_HMAX')) > 0
         zli.scale2size_type={-2};  % new gop14
    end
    
[compute] = get_all_parameters_compute_NCZLd();
[image] = get_all_parameters_image_NCZLd();
[csfparams] = get_all_parameters_csf_NCZLd();
[display_plot] = get_all_parameters_display_plot_NCZLd();



wave_n = parse_all_parameters_NCZLd(wave);
zli_n = parse_all_parameters_NCZLd(zli);
compute_n = parse_all_parameters_NCZLd(compute);
image_n = parse_all_parameters_NCZLd(image);
csfparams_n = parse_all_parameters_NCZLd(csfparams);
display_plot_n = parse_all_parameters_NCZLd(display_plot);


superstruct_n = combine_all_parameters(wave_n, zli_n, compute_n, image_n, csfparams_n, display_plot_n);


display(superstruct_n);

%for each struct in superstruct, store here 
    %or store in "combine_all_parameters" 




end

function [substruct_n] = parse_all_parameters_NCZLd(substruct)

    %para cada valor de cell, cell2mat, generar un nuevo substruct
    
    fnames = fieldnames(substruct);
    flengths = 1;
    for f=1:numel(fnames)
        fname = fnames(f);
        fname = cell2mat(fname);
        fvalues = substruct.(fname);
        flengths = flengths + (numel(fvalues)-1);
    end
    if flengths > 2
    flengths = (flengths * flengths) - flengths;
    else
        flengths = (flengths * flengths);
    end
    substruct_n = cell(flengths,1);
    
    
    for c=1:flengths
        substruct_n{c} = substruct;
    end
    
    fcount = 1;
    comb = zeros((numel(fnames))*(numel(fnames)-1)/2,2);
    for f1=1:numel(fnames)
        for f2=1:numel(fnames)
                
            if f1 ~= f2 && (comb(f1,1) ~= f2 && comb(f1,2) ~= f1)
            comb(f1,1) = f1;
            comb(f1,2) = f2;
            
            
                fname1 = fnames(f1);
                fname1 = cell2mat(fname1);
                fvalues1 = substruct.(fname1);

                fname2 = fnames(f2);
                fname2 = cell2mat(fname2);
                fvalues2 = substruct.(fname2);

                if numel(fvalues1) > 1 || numel(fvalues2) > 1

                    for l1 = 1:numel(fvalues1)
                        for l2 = 1:numel(fvalues2)
                        fcount = fcount + 1;
                        substruct_n{fcount}.(fname1) = fvalues1{l1};
                        substruct_n{fcount}.(fname2) = fvalues2{l2};
                        end
                    end
                end
            end
        end
    end
        
    
    
end

function [superstruct_n] = combine_all_parameters(wave_n, zli_n, compute_n, image_n, csfparams_n, display_plot_n)


superstruct_n = cell(numel(wave_n)+numel(zli_n)+numel(compute_n)+numel(image_n)+numel(csfparams_n)+numel(display_plot_n),1);

fcount = 0;
for w=1:numel(wave_n)
    for z=1:numel(zli_n)
        for c=1:numel(compute_n)
            for i=1:numel(image_n)
                for s=1:numel(csfparams_n)
                    for d=1:numel(display_plot_n)
                       fcount = fcount +1;
                       superstruct_n{fcount}=struct('zli',zli_n{z},'wave',wave_n{w},'csfparams',csfparams_n{c},'image',image_n{i},'display_plot',display_plot_n{d},'compute',compute_n{c});
                    end
                end
            end
        end
    end
end




end

function [wave] = get_all_parameters_wave_NCZLd()


    %wave.multires={'a_trous', 'wav', 'wav_contrast', 'curv', 'gabor', 'gabor_HMAX'};
    wave.multires={'a_trous'};
    
    wave.n_scales={0}; %auto
    
    wave.fin_scale_offset={1};
    wave.ini_scale={1};
    wave.fin_scale = {wave.ini_scale{1} + wave.fin_scale_offset{1}}; %auto
    wave.n_orient={0}; %auto

    wave.mida_min={32}; wave.nmida_min = {num2str(wave.mida_min{1})};


end

function [csfparams] = get_all_parameters_csf_NCZLd()
    %csfparams.nu_0 = num2cell(0.5:0.5:6);
    csfparams.nu_0 ={1,2,2.357,3,4,5,6};
    
    csfparams.params_intensity.fOffsetMax={0.};
    csfparams.params_intensity.fContrastMaxMax={4.981624};
    csfparams.params_intensity.fContrastMaxMin={0.};
    csfparams.params_intensity.fSigmaMax1={1.021035};
    csfparams.params_intensity.fSigmaMax2={1.048155};
    csfparams.params_intensity.fContrastMinMax={1.};
    csfparams.params_intensity.fContrastMinMin={1.};
    csfparams.params_intensity.fSigmaMin1={0.212226};
    csfparams.params_intensity.fSigmaMin2={2.};
    csfparams.params_intensity.fOffsetMin={0.530974};
    
    csfparams.params_chromatic.fOffsetMax={0.724440};
    csfparams.params_chromatic.fContrastMaxMax={3.611746};
    csfparams.params_chromatic.fContrastMaxMin={0.};
    csfparams.params_chromatic.fSigmaMax1= {1.360638};
    csfparams.params_chromatic.fSigmaMax2={0.796124};
    csfparams.params_chromatic.fContrastMinMax={1.};
    csfparams.params_chromatic.fContrastMinMin={1.};
    csfparams.params_chromatic.fSigmaMin1={0.348766};
    csfparams.params_chromatic.fSigmaMin2={0.348766};
    csfparams.params_chromatic.fOffsetMin={1.059210};

    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Z.Li's model parameters %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zli] = get_all_parameters_zli_NCZLd()

    zli.n_membr={10};
    zli.n_iter={10};
    zli.prec = {0.1};
    
    zli.n_frames_promig={zli.n_membr};
    
    %zli.dist_type={'eucl', 'manh'}; 
    zli.dist_type={'eucl'};

    zli.scalesize_type={-1};
    zli.scale2size_type={1};
    zli.scale2size_epsilon = {1.3}; zli.nepsilon={num2str(zli.scale2size_epsilon{1})};
    
    %zli.bScaleDelta=true;
    zli.bScaleDelta={true, false};
    
    %zli.reduccio_JW=num2cell(0:0.25:4);
    zli.reduccio_JW={1};

    %zli.normal_type={'all', 'scale', 'absolute'}; zli.normal_min_absolute=0; zli.normal_max_absolute=255;
    zli.normal_type={'scale'};
       

    %zli.alphax={1.0, 1.35, 1.6, 2.0};
    %zli.alphay={1.0, 1.35, 1.6, 2.0};
    zli.alphax={1.0};
    zli.alphay={1.0};
    
    %zli.nb_periods=num2cell(1:1:10);
    zli.nb_periods={5};
    zli.osc_wv={zli.nb_periods{1}*(2*pi/zli.n_membr{1})};

    %zli.normal_input=num2cell(0:0.5:5);
    %zli.normal_output=num2cell(0:0.5:5);
    zli.normal_input={2};
    zli.normal_output={2.0};	
    zli.nnormal_output={num2str(zli.normal_output{1})};
    zli.normal_min_absolute={0}; 
    zli.normal_max_absolute={0.25};

    %zli.Delta={5, 10, 15, 20, 30, 50, 100};
    zli.Delta={15};

    %zli.ON_OFF={0, 1, 2};
    zli.ON_OFF={0};

    %zli.boundary={'mirror', 'wrap'};
    zli.boundary={'mirror'};

    
    zli.normalization_power={2};

    %zli.kappax={1.0, 1.35, 1.6, 2.0}; %exc
    %zli.kappay={1.0, 1.35, 1.6, 2.0}; %inh
    zli.kappax={1.0};
    zli.kappay={1.35}; zli.nkappay={num2str(zli.kappay{1})}; 

    %zli.dedi=set_parameters_v2(2000, multires); % OP improve set_parameters
                                                % was (0,multires) for all the
                                                % experiments until 1 2 12
    %zli.dedi(1,:)=3*3*ones(1,9);
    %zli.dedi(2,:)=0*3*3*ones(1,9);
    zli.dedi = {[3*3*ones(1,9); 0*3*3*ones(1,9)]};
    
    %zli.shift={0, 1};
    zli.shift={0,1};



    %zli.scale_interaction={0, 1};
    %zli.orient_interaction={0, 1};
    zli.scale_interaction={1};
    zli.orient_interaction={1};
		
    
    
   

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% computational setting %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [compute] = get_all_parameters_compute_NCZLd()

    % Directory to work
    compute.outputstr = {'output/'};
    compute.outputstr_imgs = {}; 
    compute.outputstr_figs = {'figs'};
    compute.outputstr_mats = {'mats'};
    compute.inputstr = {'input/'};
    compute.dir={{'/home/cic/xcerda/Neurodinamic','/home/cic/xcerda/Neurodinamic/stimuli'}};
    % Jobmanager
    compute.jobmanager={'xcerda-10'}; % 'penacchio'/'xotazu'/'xcerda'/'xcerda-10'

    % Use MATLAB workers (0:no, 1:yes)
    compute.parallel={0};
    compute.parallel_channel={0};
    compute.parallel_scale={0};
    compute.parallel_ON_OFF={0};
    compute.parallel_orient={0};
    compute.dynamic={0};
    compute.multiparameters={0};

    % complexity of the set of parameters you want to study 
    if compute.multiparameters{1}==0
        compute.Nparam={1};
    else    
        compute.Nparam={size(zli.dedi{1},3)};
    end


    compute.use_fft={1};
    compute.avoid_circshift_fft={1};

    compute.XOP_DEBUG={0}; % debug (display control values)
    compute.scale_interaction_debug={0};  % debug (display scale interaction information)
    compute.XOP_activacio_neurona={0}; % impose activity to a given unit


    compute.HDR={0}; % high dynamic range

    %%%%%model output, ecsf

    % compute.output_type='image';
    % compute.output_type='saliency';

    %compute.output_from_csf= {'model','eCSF','model&eCSF'};
    compute.output_from_csf= {'eCSF'};
    
    %compute.output_from_residu= {0,1};
    compute.output_from_residu= {0};


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  stimulus (image, name...) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [image] = get_all_parameters_image_NCZLd()


    


    %image.single_or_multiple={1,2};
    image.single_or_multiple={1};
    %image.single={'mach','che','whi','whi_swirl','whi_swirl_petit'};
    image.single={'mach'};
    
     %image.multiple={'mach','che','whi'};
     %image.multiple={'whi','whi_new25','whi_new50'};
    image.multiple={'mach'};

    image.gamma={2.4};
    %image.srgb_flag = {-1,0,1};                      % -1 = rgb, 0= opponents without gamma correction. 1= opponents with gamma correction
    image.srgb_flag = {1};  
    
    %image.updown={[1],[1,2]};
    image.updown=[1];

    
    image.stim={3}; 
    image.nstripes = {0};
    
    %image.output_from_model={'M&w','M'};
     image.output_from_model='M';
    


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% display plot/store    %%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [display_plot] = get_all_parameters_display_plot_NCZLd()

    display_plot.plot_io={0};  % plot input/output (default 1)
    display_plot.reduce={0};   % 0 all (9)/ 1 reduced (useless if single_or_multiple=1) (default 0)
    display_plot.plot_wavelet_planes={0};  % display wavelet coefficients (default 0)
    display_plot.store_img_img_out={1};   % 0 don't save/ 1 save img and img_out
    
    display_plot.store={1};    % 0 don't store/ 1 iFactor, c (residual) and Ls (from decomp) and struct [default= 1]
    display_plot.store_irrelevant={0};    % 0 don't store irrelevant/ 1 store irrelevant params (J, W...)... (default= 1)
    display_plot.savefigs={0};  % save figures for stored values for iFactor, omega ...
    
    
    
    % White effect
    % display_plot.y_video=128/256;
    % display_plot.x_video=92/256;
    %display_plot.y_video=0.5;
    %display_plot.x_video=68/128;
    % dynamical case
    display_plot.y_video={65/128}; % (default 0.5)
    display_plot.x_video={65/128}; % (default 68/128)

   



end


