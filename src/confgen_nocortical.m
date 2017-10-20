function [  ] = confgen( folder)

if nargin < 1
    folder = 'conf_best5';
end

% zli_params
% wave_params
% csf_params
% color_params
% dynamic_params
% resize_params
% fusion_params
% file_params
% compute_params
% display_params
% cortex_params
% gaze_params

[wave_params] = get_all_parameters_wave_NCZLd();
[zli_params] = get_all_parameters_zli_NCZLd();


    if cell2mat(strfind(wave_params.multires,'gabor_HMAX')) > 0
         zli_params.scale2size_type={-2};  % new gop14
    end
    
[csf_params] = get_all_parameters_csf_NCZLd();
[color_params] = get_all_parameters_color_NCZLd();
%[dynamic_params] = get_all_parameters_dynamic_NCZLd();
[resize_params] = get_all_parameters_resize_NCZLd();
[fusion_params] = get_all_parameters_fusion_NCZLd();
[file_params] = get_all_parameters_file_NCZLd();
[compute_params] = get_all_parameters_compute_NCZLd();
[display_params] = get_all_parameters_display_params_NCZLd();
[gaze_params] = get_all_parameters_gaze_NCZLd();
[cortex_params] = get_all_parameters_cortex_NCZLd();


wave_n = parse_all_parameters_NCZLd(wave_params);
zli_n = parse_all_parameters_NCZLd(zli_params);
csf_n = parse_all_parameters_NCZLd(csf_params);
color_n = parse_all_parameters_NCZLd(color_params);
resize_n = parse_all_parameters_NCZLd(resize_params);
fusion_n = parse_all_parameters_NCZLd(fusion_params);
file_n = parse_all_parameters_NCZLd(file_params);
compute_n = parse_all_parameters_NCZLd(compute_params);
display_n = parse_all_parameters_NCZLd(display_params);
gaze_n = parse_all_parameters_NCZLd(gaze_params);
cortex_n = parse_all_parameters_NCZLd(cortex_params);

superstruct_n = combine_all_parameters(wave_n, zli_n, csf_n, color_n, resize_n, fusion_n, file_n, compute_n, display_n, gaze_n, cortex_n);


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

function [superstruct_n] = combine_all_parameters(wave_n, zli_n, csf_n, color_n, resize_n, fusion_n, file_n, compute_n, display_n, gaze_n, cortex_n)


superstruct_n = cell(numel(wave_n)*numel(zli_n)*numel(csf_n)*numel(color_n)*numel(resize_n)*numel(fusion_n)*numel(file_n)*numel(display_n)*numel(gaze_n)*numel(cortex_n),1);

fcount = 0;
for a=1:numel(wave_n)
    for b=1:numel(zli_n)
        for c=1:numel(csf_n)
            for d=1:numel(color_n)
                for e=1:numel(resize_n)
                    for f=1:numel(fusion_n)
                        for g=1:numel(file_n)
                            for h=1:numel(compute_n)
                                for i=1:numel(display_n)
                                    for j=1:numel(gaze_n)
                                        for k=1:numel(cortex_n)
                                           fcount = fcount +1;
                                           superstruct_n{fcount}=struct('wave_params',wave_n{a},'zli_params',zli_n{b},'csf_params',csf_n{c},'color_params',color_n{d},'resize_params',resize_n{e},'fusion_params',fusion_n{f},'file_params',file_n{g},'compute_params',compute_n{h},'display_params',display_n{i},'gaze_params',gaze_n{j},'cortex_params',cortex_n{k});
                                        end
                                    end
                                end
                            end
                        end
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
        save([folder '/' 'no_cortical_config_' int2str(ss) '.mat'],'matrix_in');
    end
end

function [wave_params] = get_all_parameters_wave_NCZLd()


    %wave_params.multires={'a_trous', 'wav', 'wav_contrast', 'curv', 'gabor', 'gabor_HMAX', 'a_trous4'};
    wave_params.multires={'a_trous','a_trous4'};
    
    wave_params.n_scales={0}; %auto
    
    wave_params.fin_scale_offset={1};
    wave_params.ini_scale={1};
    wave_params.fin_scale = {wave_params.ini_scale{1} + wave_params.fin_scale_offset{1}}; %auto
    wave_params.n_orient={0}; %auto

    wave_params.mida_min={8}; wave_params.nmida_min = {num2str(wave_params.mida_min{1})};


end

function [csf_params] = get_all_parameters_csf_NCZLd()
    %csf_params.nu_0 = num2cell(0.5:0.5:6);
    %csf_params.nu_0 ={2.357,4}; 
    csf_params.nu_0 ={4};
    
    %xavi
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
    
    
    %naila
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

    csf_params.params_intensity = {profile2.params_intensity};
    csf_params.params_chromatic = {profile2.params_chromatic};
    
    
    
end


function [color_params] = get_all_parameters_color_NCZLd()
    color_params.gamma={2.4};
    %color_params.srgb_flag = {-1,0,1};                      % -1 = rgb, 0= opponents without gamma correction. 1= opponents with gamma correction
    color_params.srgb_flag = {1};  
    
    %color_params.HDR={0}; % high dynamic range
    %color_params.orgb_flag= {1,0};
    color_params.orgb_flag= {0}; %put smap back to rgb

    %color_params.nchannels = 3;
    
end


function [dynamic_params] = get_all_parameters_dynamic_NCZLd()

        %dynamic_params.stim={3}; 
        %dynamic_params.dynamic={0};
end

function [resize_params] = get_all_parameters_resize_NCZLd() 
    %resize_params.autoresize_ds = {-1,0,1,2,3,4}; %-1 = resize to get < 256, 0 = not resize, > 0 = 2^ds
    resize_params.autoresize_ds = {-1};
    %resize_params.updown={[1],[1,2]};
    %resize_params.updown=[1];
    %resize_params.autoresize_nd = {0,10}; %proportion between image size and window size
    resize_params.autoresize_nd = {0};
    resize_params.M = {0}; %auto
    resize_params.N = {0}; %auto
end

function [fusion_params] = get_all_parameters_fusion_NCZLd() 
    %fusion_params.output_from_model={'M&w','M'};
    fusion_params.output_from_model={'M'};
    
    %fusion_params.output_from_csf= {'iFactor','eCSF'};
    fusion_params.output_from_csf= {'iFactor'};
    
    %fusion_params.residual_wave= {0,1,2};
    fusion_params.residual_wave= {0,1,2};

    %fusion_params.smethod= {'sqmean','pmax','pmaxc','pmax2','wtamaxc','wtamax2','wta','wta2'}; %fusion method
    fusion_params.smethod= {'sqmean','pmax','pmaxc','pmax2','wtamaxc','wtamax2','wta','wta2'};

    %fusion_params.fusion= {1,2,3,4,5}; %normalization
    fusion_params.fusion= {1,2,3,4,5};

    %fusion_params.tmem_res = {'mean','max'}; %temporal mean of iFactor or temporal max?
    fusion_params.tmem_res = {'mean','max'}; 
    
    %fusion_params.inverse = {'default','max','wta'};
    fusion_params.inverse={'default','max','wta'};
    
    %fusion_params.gsp={0,n} smoothing parameter
    fusion_params.gsp={0,1};
    
    %fusion_params.ior_smap={1,0}; %get gaussian map according to ior or fixed at 40 dva
    fusion_params.ior_smap={1};
end

function [file_params] = get_all_parameters_file_NCZLd()

    file_params.name = {'image'};
    
        % Directory to work
    file_params.outputstr = {'output/'};
    file_params.outputstr_imgs = {''}; 
    file_params.outputstr_figs = {'figs'};
    file_params.outputstr_mats = {'mats'};
    file_params.inputstr = {'input/'};
    file_params.dir={{'/home/cic/xcerda/Neurodinamic','/home/cic/xcerda/Neurodinamic/stimuli'}};

    %file_params.delete_mats= {0,1};
    file_params.delete_mats= {0};
    
    file_params.unique_mats_folder= {0};
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Z.Li's model parameters %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zli_params] = get_all_parameters_zli_NCZLd()

    zli_params.n_membr={10};
    zli_params.n_iter={10};
    zli_params.prec = {0.1};
    
    %zli_params.n_frames.promig=num2cell(1:1:10);
    %zli_params.n_frames_promig={7,10};
    zli_params.n_frames_promig={10};
    
    %zli_params.dist_type={'eucl', 'manh'}; 
    zli_params.dist_type={'eucl'};

    zli_params.scalesize_type={-1};
    zli_params.scale2size_type={1};
    zli_params.scale2size_epsilon = {1.3}; zli_params.nepsilon={num2str(zli_params.scale2size_epsilon{1})};
    
    %zli_params.bScaleDelta={0,1};
    zli_params.bScaleDelta={0,1};
    
    %zli_params.reduccio_JW=num2cell(0:0.25:4);
    zli_params.reduccio_JW={1};

    %zli_params.normal_type={'all', 'scale', 'absolute'}; zli_params.normal_min_absolute=0; zli_params.normal_max_absolute=255;
    zli_params.normal_type={'scale'};
       

    %zli_params.alphax={1.0, 1.35, 1.6, 2.0};
    %zli_params.alphay={1.0, 1.35, 1.6, 2.0};
    zli_params.alphax={1.0};
    zli_params.alphay={1.0};
    
    %zli_params.nb_periods=num2cell(1:1:10);
    zli_params.nb_periods={5};
    zli_params.osc_wv={zli_params.nb_periods{1}*(2*pi/zli_params.n_membr{1})};

    %zli_params.normal_input=num2cell(0:0.5:5);
    %zli_params.normal_output=num2cell(0:0.5:5);
    zli_params.normal_input={2};
    zli_params.normal_output={2.0};	
    zli_params.nnormal_output={num2str(zli_params.normal_output{1})};
    zli_params.normal_min_absolute={0}; 
    zli_params.normal_max_absolute={0.25};

    %zli_params.Delta={5, 10, 15, 20, 30, 50, 100};
    zli_params.Delta={15};

    %zli_params.ON_OFF={0, 1, 2};
    zli_params.ON_OFF={0};

    %zli_params.boundary={'mirror', 'wrap'};
    zli_params.boundary={'mirror'};

    
    zli_params.normalization_power={2};

    %zli_params.kappax={1.0, 1.35, 1.6, 2.0}; %exc
    %zli_params.kappay={1.0, 1.35, 1.6, 2.0}; %inh
    zli_params.kappax={1.0};
    zli_params.kappay={1.35}; zli_params.nkappay={num2str(zli_params.kappay{1})}; 

    %zli_params.dedi=set_parameters_v2(2000, multires); % OP improve set_parameters
                                                % was (0,multires) for all the
                                                % experiments until 1 2 12
    %zli_params.dedi(1,:)=3*3*ones(1,9);
    %zli_params.dedi(2,:)=0*3*3*ones(1,9);
    zli_params.dedi = {[3*3*ones(1,9); 0*3*3*ones(1,9)]};
    
    %zli_params.shift={0, 1};
    zli_params.shift={1};



    %zli_params.scale_interaction={0, 1};
    %zli_params.orient_interaction={0, 1};
    zli_params.scale_interaction={1};
    zli_params.orient_interaction={1};
		
    
    
   

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% computational setting %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [compute_params] = get_all_parameters_compute_NCZLd()

    compute_params.model = {1}; %matlab
    % Jobmanager
    compute_params.jobmanager={'xcerda-10'}; % 'penacchio'/'xotazu'/'xcerda'/'xcerda-10'

    % Use MATLAB workers (0:no, 1:yes)
    compute_params.parallel={0};
    compute_params.parallel_channel={0};
    compute_params.parallel_scale={0};
    compute_params.parallel_ON_OFF={0};
    compute_params.parallel_orient={0};

    %compute_params.multiparameters={0};

    % complexity of the set of parameters you want to study 
%     if compute_params.multiparameters{1}==0
%         compute_params.Nparam={1};
%     else    
%         compute_params.Nparam={size(zli_params.dedi{1},3)};
%     end


    compute_params.use_fft={1};
    compute_params.avoid_circshift_fft={1};

    compute_params.XOP_activacio_neurona={0}; % impose activity to a given unit




end


function [cortex_params] = get_all_parameters_cortex_NCZLd()

        %cortex_params.cm_method = {'schwartz_monopole','schwartz_dipole'};
        cortex_params.cm_method = {'schwartz_monopole'};
        cortex_params.cortex_width = {128};
        cortex_params.a={degtorad(0.77)}; %schira's code
        cortex_params.b={degtorad(150)}; %schira's code
        %cortex_params.lambda={12,18};
        cortex_params.lambda={12,18};
        cortex_params.isoPolarGrad={0.1821};
        cortex_params.eccWidth={0.7609};
        cortex_params.cortex_max_elong_mm = {120};
        cortex_params.cortex_max_az_mm = {60};
        %cortex_params.mirroring = {1,0};
        cortex_params.mirroring = {1};
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  stimulus (image, name...) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gaze_params] = get_all_parameters_gaze_NCZLd()

        gaze_params.orig_width = {0}; %unknown on undistort
        gaze_params.orig_height = {0}; %unknown on undistort
        gaze_params.fov_x = {0}; %auto
        gaze_params.fov_y = {0}; %auto
        %gaze_params.img_diag_angle = {degtorad(35.12),degtorad(44.12)};
        gaze_params.img_diag_angle = {degtorad(35.12)}; %used on magnification
        gaze_params.ior = {0};
        gaze_params.ior_factor_ctt = {nthroot(0.001,1600)}; %samuel & kat 2003 %(Xms=Nsaccades*10tmem*10ms/tmem) 
        gaze_params.ior_angle = {degtorad(4)}; %not used, using scale corresponding to output
        gaze_params.ior_matrix = {0}; %starting ior
        gaze_params.conserve_dynamics = {1};
        gaze_params.conserve_dynamics_rest = {1};

    gaze_params.foveate = {0};
    %gaze_params.foveate = {0,1,3};
    %gaze_params.fov_type = {'cortical_xavi','cortical_xavi_mirrored','cortical', 'gaussian', 'fisheye'};
    gaze_params.fov_type = {'cortical'};
 

    %gaze_params.redistort_periter = {1,0};
    gaze_params.redistort_periter = {1};

    gaze_params.ngazes = {10};
    %gaze_params.ngazes = {2,5,10};
    gaze_params.gaze_idx = {0};

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% display plot/store    %%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [display_params] = get_all_parameters_display_params_NCZLd()

    display_params.plot_io={0};  % plot input/output (default 1)
    display_params.reduce={0};   % 0 all (9)/ 1 reduced (useless if single_or_multiple=1) (default 0)
    display_params.plot_wavelet_planes={0};  % display wavelet coefficients (default 0)
    display_params.store_img_img_out={1};   % 0 don't save/ 1 save img and img_out
    
    display_params.store={1};    % 0 don't store/ 1 iFactor, c (residual) and Ls (from decomp) and struct [default= 1]
    display_params.store_irrelevant={0};    % 0 don't store irrelevant/ 1 store irrelevant params (J, W...)... (default= 1)
    display_params.savefigs={0};  % save figures for stored values for iFactor, omega ...
    
    
    display_params.XOP_DEBUG={0}; % debug (display control values)
    display_params.scale_interaction_debug={0};  % debug (display scale interaction information)
    
    % White effect
    % display_params.y_video=128/256;
    % display_params.x_video=92/256;
    %display_params.y_video=0.5;
    %display_params.x_video=68/128;
    % dynamical case
    display_params.y_video={65/128}; % (default 0.5)
    display_params.x_video={65/128}; % (default 68/128)

   



end


