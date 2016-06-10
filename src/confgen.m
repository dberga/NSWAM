function [  ] = confgen( folder)

if nargin < 1
    folder = 'conf3';
end

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


%display(superstruct_n);

%for each struct in superstruct, store here 
    %or store in "combine_all_parameters" 
    store_superstruct(superstruct_n,folder);



end

function [substruct_n] = parse_all_parameters_NCZLd(substruct)

    %para cada valor de cell, cell2mat, generar un nuevo substruct
    
    fnames = fieldnames(substruct);

    %count permutations of parameters
    fcount = 0;
    for f1=1:numel(fnames)
            for f2=1:numel(fnames)

                if f2 > f1

                    fname1 = fnames(f1);
                    fname1 = cell2mat(fname1);
                    fvalues1 = substruct.(fname1);

                    fname2 = fnames(f2);
                    fname2 = cell2mat(fname2);
                    fvalues2 = substruct.(fname2);

                    if numel(fvalues1) > 1 
                        if numel(fvalues2) > 1
                            for l1 = 1:numel(fvalues1)
                                for l2 = 1:numel(fvalues2)
                                    fcount = fcount + 1;
                                end
                            end
                        else
                            
                            
                        end
                    end
                end
            end
        end
    if fcount == 0
        scount = 0;
        %substruct_n{1} = substruct;
        used = false;
        for f1=1:numel(fnames)
            for f2=1:numel(fnames)
                if f2 > f1

                    fname1 = fnames(f1);
                    fname1 = cell2mat(fname1);
                    fvalues1 = substruct.(fname1);

                    fname2 = fnames(f2);
                    fname2 = cell2mat(fname2);
                    fvalues2 = substruct.(fname2);
                    
                    

                    if numel(fvalues1) > 1 
                        if used == false
                            for l1 = 1:numel(fvalues1)
                                scount = scount + 1;
                            end
                            used = true;
                        end
                    end
                end
            end
        end
    end
    
   
    
    %reserve cell space
    if fcount == 0
        if scount == 0
            substruct_n = cell(1,1);
            substruct_n{1} = substruct;
        else
            substruct_n = cell(scount,1);
            for c=1:scount
                substruct_n{c} = substruct;
            end
        end
        
    else
        
        substruct_n = cell(fcount,1);
        for c=1:fcount
            substruct_n{c} = substruct;
        end
    end
    
    %if there is no parameter with multiple values, pick 1 as all
    if fcount == 0
        scount = 0;
        %substruct_n{1} = substruct;
        used = false;
        for f1=1:numel(fnames)
            for f2=1:numel(fnames)
                if f2 > f1

                    fname1 = fnames(f1);
                    fname1 = cell2mat(fname1);
                    fvalues1 = substruct.(fname1);

                    fname2 = fnames(f2);
                    fname2 = cell2mat(fname2);
                    fvalues2 = substruct.(fname2);
                    
                    

                    if numel(fvalues1) > 1 
                        if used == false
                            for l1 = 1:numel(fvalues1)
                                scount = scount + 1;
                                    substruct_n{scount}.(fname1) = fvalues1{l1};
                                
                            end
                            used = true;
                        end
                    end
                end
            end
        end
    
    else
        %for each parameter with multiple values, combine
        fcount = 0;

        
        for f1=1:numel(fnames)
            for f2=1:numel(fnames)

                if f2 > f1

                    fname1 = fnames(f1);
                    fname1 = cell2mat(fname1);
                    fvalues1 = substruct.(fname1);

                    fname2 = fnames(f2);
                    fname2 = cell2mat(fname2);
                    fvalues2 = substruct.(fname2);

                    if numel(fvalues1) > 1 
                        if numel(fvalues2) > 1
                            for l1 = 1:numel(fvalues1)
                                for l2 = 1:numel(fvalues2)
                                    fcount = fcount + 1;
                                substruct_n{fcount}.(fname1) = fvalues1{l1};
                                substruct_n{fcount}.(fname2) = fvalues2{l2};
                                end
                            end
                        else
                            
                            
                        end
                    end
                end
            end
        end
    end
    
    
%     for sn1=1:numel(substruct_n)
%             for sn2=1:numel(substruct_n)
%                 if sn2 > sn1
%                     if isequal(substruct_n{sn1},substruct_n{sn2}) == 1
%                         substruct_n{sn2} = [];
%                     end
%                 end
%             end
%     end
%     substruct_n = substruct_n(~cellfun('isempty',substruct_n));
    
%from cells to numbers, clean
for sn1=1:numel(substruct_n)
    for f1=1:numel(fnames)
        fname1 = fnames(f1);
        fname1 = cell2mat(fname1);
        fvalues1 = substruct.(fname1);
        if iscell(substruct_n{sn1}.(fname1)) == true
            substruct_n{sn1}.(fname1) = fvalues1{1};
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
                       superstruct_n{fcount}=struct('zli',zli_n{z},'wave',wave_n{w},'csfparams',csfparams_n{s},'image',image_n{i},'display_plot',display_plot_n{d},'compute',compute_n{c});
                    end
                end
            end
        end
    end
end



end

function [] = store_superstruct(superstruct_n,folder)
    for ss=1:numel(superstruct_n)
        matrix_in = superstruct_n{ss};
        save([folder '/' 'config_' int2str(ss)],'matrix_in');
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
    csfparams.nu_0 ={2,2.357,3,4,5};
    
    
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
    
    
    csfparams.params_intensity = {profile1.params_intensity, profile2.params_intensity};
    csfparams.params_chromatic = {profile1.params_chromatic, profile2.params_chromatic};
    
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Z.Li's model parameters %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zli] = get_all_parameters_zli_NCZLd()

    zli.n_membr={10};
    zli.n_iter={10};
    zli.prec = {0.1};
    
    zli.n_frames_promig={5,6,7,8,9,10};
    
    %zli.dist_type={'eucl', 'manh'}; 
    zli.dist_type={'eucl'};

    zli.scalesize_type={-1};
    zli.scale2size_type={1};
    zli.scale2size_epsilon = {1.3}; zli.nepsilon={num2str(zli.scale2size_epsilon{1})};
    
    %zli.bScaleDelta=true,false;
    zli.bScaleDelta={true};
    
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
    zli.shift={1};



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
    compute.outputstr_imgs = {''}; 
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

    %compute.output_from_csf= {'iFactor','eCSF'};
    compute.output_from_csf= {'iFactor','eCSF'};
    
    %compute.output_from_residu= {0,1};
    compute.output_from_residu= {0};

    %compute.smethod= {'sqmean','pmax','pmaxc','pmax2','wta'};
    compute.smethod= {'sqmean','pmax','pmaxc','pmax2','wta'};
    
    %compute.delete_mats= {0,1};
    compute.delete_mats= {0};
    
    %compute.orgb_flag= {1,0};
    compute.orgb_flag= {0};
    
    %compute.fusion= {1,2,3,4,5,6};
    compute.fusion= {1,2,3,4,5,6};

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  stimulus (image, name...) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [image] = get_all_parameters_image_NCZLd()


    

    image.name = {'image'};
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

    %image.foveate = {0,1};
    image.foveate = {0};
    %image.fov_type = {'cortical_xavi','cortical', 'gaussian', 'fisheye'};
    image.fov_type = {'cortical_xavi'};
 
    %image.output_from_model={'M&w','M'};
     image.output_from_model='M';
    
    %image.autoresize_ds = {-1,0,1,2,3,4}; %-1 = resize to get < 1024, 0 = not resize, > 0 = 2^ds
    image.autoresize_ds = {0};

    %image.autoresize_nd = {0,10}; %proportion between image size and window size
    image.autoresize_nd = {10};

    %image.tmem_res = {'mean','max'}; %temporal mean of iFactor or temporal max?
    image.tmem_res = {'mean'}; 

    image.fixationX = {0}; %auto
    image.fixationY = {0}; %auto


    image.M = {0}; %auto
    image.N = {0}; %auto


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


