function [smap,scanpath] = saliency(input_image,image_name,conf_struct_path,output_folder,output_folder_mats,output_extension)

%non modified input_image
aux_input_image = input_image;

%%%%%%%%%%%%%%%%%%default arguments (nargin)
if ~exist('output_extension','var')    output_extension = 'png'; end
if ~exist('output_folder','var')    output_folder = 'output'; end
if ~exist('output_folder_mats','var')   output_folder_mats = 'mats'; end
if ~exist('conf_struct_path','var')    conf_struct_path = ''; end


%%%%%%%%%%%%%%%%%%LOAD/CREATE CONFIG STRUCT PARAMS

[~,conf_struct_path_name,~] = fileparts(conf_struct_path);
if strcmp(conf_struct_path,'')==0
    
    [conf_struct] = load(conf_struct_path); conf_struct = conf_struct.matrix_in;
else
    [conf_struct] = get_default_parameters();
end

%discriminate if no foveation
if  conf_struct.gaze_params.foveate == 0
    conf_struct.gaze_params.ngazes = 1;
end
%color or grayscale image
conf_struct.color_params.nchannels = size(input_image,3);
conf_struct.color_params.channels = {'chromatic','chromatic2','intensity'};

%set gaze parameters
conf_struct.resize_params.M = size(aux_input_image,1);
conf_struct.resize_params.N = size(aux_input_image,2);
conf_struct.gaze_params.orig_height = conf_struct.resize_params.M;
conf_struct.gaze_params.orig_width = conf_struct.resize_params.N;
if conf_struct.gaze_params.fov_x == 0 && conf_struct.gaze_params.fov_y == 0
    conf_struct.gaze_params.fov_y =round(conf_struct.gaze_params.orig_height/2); 
    conf_struct.gaze_params.fov_x =round(conf_struct.gaze_params.orig_width/2); 
end

%folders of mats separate or not? (to avoid overwriting)
%if ~conf_struct.file_params.unique_mats_folder
    output_folder_mats = [output_folder_mats '/' conf_struct_path_name];
%end


%%%%%%%%%%%%%%%%%%INITIALIZE OUTPUT
[M,N,C] = size(input_image);
smap = zeros(M,N);
smaps = zeros(M,N,conf_struct.gaze_params.ngazes);
scanpath = zeros(conf_struct.gaze_params.ngazes+1,2);

iFactors = cell(1,3);
curvs = cell(1,3);
residuals = cell(1,3);
%%%%%%%%%%%%%%%%%%get folder_props and image_props
[folder_props] = get_folder_properties(output_folder,conf_struct_path_name,output_folder_mats,output_extension);
[image_props] = get_image_properties(input_image,image_name,folder_props,conf_struct);
[mat_props] = get_mat_properties(folder_props,image_props,conf_struct);


%%%%%%%%%%%%%%%%%%GET RUN FLAGS (LOAD,NEURODYN,RECONS...)
[run_flags] = get_run_flags(image_props,mat_props,conf_struct);


if run_flags.run_all==1
    if run_flags.run_smaps
        for k=1:conf_struct.gaze_params.ngazes
            disp(['Gaze :' int2str(k)]);
            
            input_image = double(aux_input_image);

            %%%%%%%%%%%%% 1.foveate (or mapping)
            [input_image] = get_foveate(input_image,conf_struct);

            %%%%%%%%%%%%% resize (if foveated, do not resize)
            [input_image] = get_resize(input_image,conf_struct);
            
            %%%%%%%%%%%%% save loaded struct properties
            [loaded_struct,conf_struct] = get_loaded_struct(run_flags,folder_props,image_props,mat_props,conf_struct,input_image,k);

            %%%%%%%%%%%%% 2.im2opponent
            input_image = get_the_cstimulus(input_image,loaded_struct.color_params.gamma,loaded_struct.color_params.srgb_flag);%! color  to opponent

            %%%%%%%%%%%%% 3. DWT
            [curvs,residuals] = get_DWT(run_flags,loaded_struct,folder_props,image_props,C,k,input_image);

            
            %%%%%%%%%%%%% 4. CORE, COMPUTE DYNAMICS
            [iFactors] = get_dynamics(run_flags,loaded_struct,folder_props,image_props,C,k,curvs,residuals);

            if isempty(iFactors)
                return;
            end
            
            %%%%%%%%%%%%% 5. FUSION

            %residual to zero?
            [residuals{1}] = get_residual_updated(loaded_struct,residuals{1});
            [residuals{2}] = get_residual_updated(loaded_struct,residuals{2});
            [residuals{3}] = get_residual_updated(loaded_struct,residuals{3});
            
            residual_s_c = cs2sc(residuals,loaded_struct.color_params.nchannels,loaded_struct.wave_params.n_scales);
            
            %change its cell dimensions back to its format
            RF_ti_s_o_c = unify_channels_ti(iFactors{1},iFactors{2},iFactors{3},loaded_struct);
                %residual_c_s = unify_channels_norient(residuals{1},residuals{2},residuals{3},loaded_struct);

            %temporal mean for RF
            RF_s_o_c = timatrix_to_matrix(RF_ti_s_o_c,loaded_struct);

            %eCSF
            [RF_s_o_c] = get_eCSF(loaded_struct,RF_s_o_c);
            
            % max of RF (orientation and channel), copy afterwards
            [RF_c_s_o,~] = get_maxRF(loaded_struct,RF_s_o_c,residual_s_c);
                
                
            %IDWT
            RF_c_s_o{1} = so2s_o(RF_c_s_o{1},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            RF_c_s_o{2} = so2s_o(RF_c_s_o{2},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            RF_c_s_o{3} = so2s_o(RF_c_s_o{3},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            %[RF_c_s_o{1},residual_c_s{1}] = multires_curv2decomp(RF_c_s_o{1},residual_c_s{1},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            %[RF_c_s_o{2},residual_c_s{2}] = multires_curv2decomp(RF_c_s_o{2},residual_c_s{2},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            %[RF_c_s_o{3},residual_c_s{3}] = multires_curv2decomp(RF_c_s_o{3},residual_c_s{3},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                
            [RF_c] = get_IDWT(loaded_struct,RF_c_s_o,residuals);
            
            %from opponent to color (depending on flag)
            [RF_c] = get_opp2rgb(loaded_struct,RF_c);

            %combine channels
            [smap] = get_combine_channels(loaded_struct,RF_c);

            %undistort
            smap = get_undistort(loaded_struct,smap);
            
            %deresize to original size
            smap = get_deresize(loaded_struct,smap);
            
            %normalize
            smap = get_normalize(loaded_struct,smap);

            %save
            imwrite(smap, image_props.output_image_paths{k});

            %delete files
            run_delete_files(folder_props,image_props,loaded_struct,k);
            
            
            %update fov_x and fov_y
            [maxval, maxidx] = max(smap(:));
            [conf_struct.gaze_params.fov_y, conf_struct.gaze_params.fov_x] = ind2sub(size(smap),maxidx); %x,y
            
            %iterate
            smaps(:,:,k) = smap;
        end
    end
    
    %scanpath from files or from computed smaps(k)
    scanpath = run_scanpath(run_flags,image_props,conf_struct,smaps);
    
    %smap from means of gazed smaps
    mean_smap = run_mean(run_flags,image_props,conf_struct,smaps);
    
    %smap from density of scanpath
    saccades_gaussian = run_gaussian(run_flags,image_props,conf_struct,scanpath);
    
    %binary map from scanpath
    saccades_bmap = run_bmap(run_flags,image_props,conf_struct,scanpath);
    
    
    
    smap = mean_smap;

end

end


function [input_image] = get_foveate(input_image,conf_struct)
    if conf_struct.gaze_params.foveate == 1
        input_image = foveate(input_image,0,conf_struct);
    end
end
function [input_image] = get_resize(input_image,conf_struct)
    if conf_struct.gaze_params.foveate == 0
        %resize functions
        if conf_struct.resize_params.autoresize_ds ~= -1    
            input_image = autoresize(input_image,conf_struct.resize_params.autoresize_ds);
        else
            input_image = autoresize(input_image);
        end
        if conf_struct.resize_params.autoresize_nd ~= 0
            input_image = autoresize_nd(input_image,conf_struct.zli_params.Delta,conf_struct.zli_params.reduccio_JW,conf_struct.resize_params.autoresize_nd);
        end
    end
             
end
function [loaded_struct,conf_struct] = get_loaded_struct(run_flags,folder_props,image_props,mat_props,conf_struct,input_image,gaze_idx)
            
            %get scales, orientations
            [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(input_image, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
            [conf_struct.wave_params.n_orient] = calc_norient(input_image,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);

            %loaded struct from mats folder
            if run_flags.load_struct(gaze_idx)==1    
                [loaded_struct] = load(mat_props.loaded_struct_path{gaze_idx}); loaded_struct = loaded_struct.matrix_in;

                %for reconstruction, we can use post-calculation params
                loaded_struct.fusion_params = conf_struct.fusion_params;
                loaded_struct.csf_params = conf_struct.csf_params;
            else    
                [loaded_struct] = conf_struct;
                save_mat('struct',loaded_struct,folder_props,image_props,gaze_idx);
            end
            
end
function [curvs,residuals] = get_DWT(run_flags,loaded_struct,folder_props,image_props,C,gaze_idx,input_image)
            
        curvs = cell(C,1);
        residuals = cell(C,1);
            for c=1:C
                if run_flags.load_WavCurv_mats(gaze_idx)==1 && run_flags.load_WavResidual_mats(gaze_idx)==1
                    [curv] = load(get_mat_name('w',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c})); curv = curv.matrix_in;
                    [residual] = load(get_mat_name('c',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c})); residual = residual.matrix_in;
                    curv = curv(~cellfun('isempty',curv)); %clean void cells
                    residual = residual(~cellfun('isempty',residual)); %clean void cells

                else
                    [curv,residual] = multires_dispatcher(input_image(:,:,c), loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales, loaded_struct.wave_params.n_orient);
                    save_mat('w',curv,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c});
                    save_mat('c',residual,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c});

                end
                curvs{c} = curv;
                residuals{c} = residual;
                
                
            end
            
            if C < 2
            % grayscale case: copy to other channels
            curvs{2} = curvs{1};
            curvs{3} = curvs{1};
            save_mat('w',curvs{2},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
            save_mat('w',curvs{3},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});
            

            
            residuals{2} = residuals{1};
            residuals{3} = residuals{1};
            save_mat('residual',residuals{2},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
            save_mat('residual',residuals{3},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});
            
            end
end



function [iFactors] = get_dynamics(run_flags,loaded_struct,folder_props,image_props,C,gaze_idx,curvs,residuals)
                
    iFactors = cell(1,C);
    for c=1:C
            
        if run_flags.load_iFactor_mats(gaze_idx)==1 && run_flags.load_struct(gaze_idx)==1
            iFactor = load(get_mat_name('iFactor',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c})); iFactor = iFactor.matrix_in;
            %iFactor = iFactor(~cellfun('isempty',iFactor)); %clean void cells
        else
            t_ini = tic;
            switch loaded_struct.compute_params.model
                case -1
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% empty, do not process anything %%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    return;
                case 0
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% COPY (only curv from DWT, dynamic = tmem copies) %%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    iFactor = multires_decomp2dyndecomp(curvs{c},residuals{c},loaded_struct.zli_params.n_membr,loaded_struct.zli_params.n_iter,loaded_struct.wave_params.n_scales);

                case 1
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% NEURODYNAMIC IN MATLAB %%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    [iFactor, iFactor_ON, iFactor_OFF, jFactor_ON, jFactor_OFF] =NCZLd_channel_ON_OFF(curvs{c},loaded_struct,loaded_struct.color_params.channels{c});

                case 2
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% NEURODYNAMIC IN C++ %%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [iFactor_single,iFactor] = NCZLd_periter_mex(curvs{c},loaded_struct); %iFactor_single has mean of memtime and iter (scale and orientation dimensions)

            end
            toc(t_ini);
            
            
        
            %change its cell dimensions format
            for ff=1:loaded_struct.zli_params.n_membr
                     for iter=1:loaded_struct.zli_params.n_iter
                         [iFactor{ff}{iter},~] = multires_decomp2curv(iFactor{ff}{iter},residuals{c},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                     end
            end
            
            
            % save computed iFactor
            save_mat('iFactor',iFactor,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c});
            
           
        end
        
        iFactors{c} = iFactor;
        
        
        
    
    end
    
        if C < 2
        %case grayscale
        iFactors{2} = iFactors{1};
        iFactors{3} = iFactors{1};
        save_mat('iFactor',iFactors{2},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
        save_mat('iFactor',iFactors{3},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});
        
        end
end

function [residuals] = get_residual_updated(loaded_struct,residuals)
            switch loaded_struct.fusion_params.residual_wave
                case 0
                    for s=1:loaded_struct.wave_params.n_scales-1
                        residuals{s} = zeros(size(residuals{s}));
                    end
                case 1
                    for s=1:loaded_struct.wave_params.n_scales-1
                        residuals{s} = zeros(size(residuals{s})) +1;
                    end
                otherwise
                    %keep it as it is
            end
end


function [RF_s_o_c] = get_eCSF(loaded_struct,RF_s_o_c)
            if strcmp(loaded_struct.fusion_params.output_from_csf,'eCSF') == 1
                [RF_s_o_c] = apply_eCSF_percanal(RF_s_o_c, loaded_struct);
            end
            
end

function [RF_c_s_o,residual_c_s] = get_maxRF(loaded_struct,RF_s_o_c,residual_s_c)
        switch (loaded_struct.fusion_params.smethod)
            case 'pmax2'
                [RF_s,residual_s] = get_RF_max_t(RF_s_o_c,residual_s_c,loaded_struct);        
                RF_s_o = repicate_orient(RF_s,loaded_struct);
                %[RF_s_o_c{1},RF_s_o_c{2},RF_s_o_c{3}] = separate_channels(RF_s_o,loaded_struct);
                %[residual_s_c{1},residual_s_c{2},residual_s_c{3}] = separate_channels_norient(residual_s,loaded_struct);
                RF_c_s_o{1} = RF_s_o;
                RF_c_s_o{2} = RF_s_o;
                RF_c_s_o{3} = RF_s_o;
                
                %%max residual
                residual_c_s{1} = residual_s;
                residual_c_s{2} = residual_s;
                residual_c_s{3} = residual_s;
                
                %%same residual
                %residual_c_s = sc2cs(residual_s_c,loaded_struct.color_params.nchannels,loaded_struct.wave_params.n_scales);
                
            case 'pmaxc'
                [RF_s_o,residual_s] = get_RF_max_t_o(RF_s_o_c,residual_s_c,loaded_struct);  
                %[RF_s_o_c{1},RF_s_o_c{2},RF_s_o_c{3}] = separate_channels(RF_s_o,loaded_struct);
                %[residual_s_c{1},residual_s_c{2},residual_s_c{3}] = separate_channels_norient(residual_s,loaded_struct);
                
                RF_c_s_o{1} = RF_s_o;
                RF_c_s_o{2} = RF_s_o;
                RF_c_s_o{3} = RF_s_o;
                
                
                %%max residual
                residual_c_s{1} = residual_s;
                residual_c_s{2} = residual_s;
                residual_c_s{3} = residual_s;
                
                %%same residual
                %residual_c_s = sc2cs(residual_s_c,loaded_struct.color_params.nchannels,loaded_struct.wave_params.n_scales);

            otherwise
                RF_c_s_o = soc2cso(RF_s_o_c,loaded_struct.color_params.nchannels,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                residual_c_s = sc2cs(residual_s_c,loaded_struct.color_params.nchannels,loaded_struct.wave_params.n_scales);
                

        end
end
function [RF_c] = get_IDWT(loaded_struct,RF_c_s_o,residual_c_s)
            

            RF_c(:,:,1) = multires_inv_dispatcher(RF_c_s_o{1},residual_c_s{1},loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            RF_c(:,:,2) = multires_inv_dispatcher(RF_c_s_o{2},residual_c_s{2},loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
            RF_c(:,:,3) = multires_inv_dispatcher(RF_c_s_o{3},residual_c_s{3},loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
end
            
            
function [RF_c] = get_opp2rgb(loaded_struct,RF_c)
            if loaded_struct.color_params.orgb_flag == 1  
                RF_c = get_the_ostimulus(RF_c,loaded_struct.color_params.gamma,loaded_struct.color_params.srgb_flag);
            end 
end
            
function [smap] = get_combine_channels(loaded_struct,RF_c)
    switch (loaded_struct.fusion_params.smethod)
        case 'pmax2'
            smap = RF_c(:,:,1); %max opp i orient, los tres canales lo mismo
        case 'wta' 
            smap = channelwta(RF_c); %guanya nomes canal amb mes energia
        case 'pmax'  

            smap = channelmax(RF_c);	%maxim canals, despres de recons.
        case 'pmaxc'

            smap = RF_c(:,:,1); %maxim opp, los tres canales lo mismo
        case 'sqmean'
            smap = channelsqmean(RF_c);
        otherwise
            smap = channelsqmean(RF_c);
    end

end

function [smap] = get_deresize(loaded_struct,smap)
    if loaded_struct.resize_params.autoresize_ds ~= 0 || loaded_struct.resize_params.autoresize_nd ~=0
        smap = imresize(smap,[loaded_struct.gaze_params.orig_height loaded_struct.gaze_params.orig_width]);
    end

end

function [smap] = get_undistort(loaded_struct,smap)
            if loaded_struct.gaze_params.foveate == 1
                smap = foveate(smap,1,loaded_struct);
            end

end

function [smap] = get_normalize(loaded_struct,smap)

    switch(loaded_struct.fusion_params.fusion)
        case 1	

              smap = normalize_energy(smap);

        case 2

              smap = normalize_Z(smap);
        case 3

            smap = normalize_Zp(smap);

        otherwise
            %do nothing
    end
            
    smap = normalize_minmax(smap); 
    
    

end

function [] = run_delete_files(folder_props,image_props,loaded_struct,gaze_idx)
    delete_files = loaded_struct.file_params.delete_mats; %delete mats after creating imgs (0=no, 1=yes)
    if delete_files == 1
        delete(get_mat_name('struct',folder_props,image_props,gaze_idx));
        delete(get_mat_name('iFactor',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{1}));
        delete(get_mat_name('iFactor',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2}));
        delete(get_mat_name('iFactor',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3}));
        delete(get_mat_name('w',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{1}));
        delete(get_mat_name('w',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2}));
        delete(get_mat_name('w',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3}));
        delete(get_mat_name('c',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{1}));
        delete(get_mat_name('c',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2}));
        delete(get_mat_name('c',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3}));

    end

end

function [smaps] = get_smaps(image_props,conf_struct)
    for k=1:conf_struct.gaze_params.ngazes
              smaps(:,:,k)=double(imread(image_props.output_image_paths{k})); 
    end

end

function [scanpath] = run_scanpath(run_flags,image_props,conf_struct,smaps)
    if run_flags.run_scanpath
        for k=1:conf_struct.gaze_params.ngazes
            if run_flags.load_smap(k)
                  smaps(:,:,k)=double(imread(image_props.output_image_paths{k})); 
            else
               %we have already computed the smaps(k) on previous loop
            end
        end
        [scanpath] = get_scanpath(smaps,conf_struct);
        
        save(image_props.output_scanpath_path,'scanpath');


    else
        scanpath = load(image_props.output_scanpath_path); scanpath = scanpath.scanpath;
    end
end
function [mean_smap] = run_mean(run_flags,image_props,conf_struct,smaps)
    if run_flags.run_mean 
        
        for k=1:conf_struct.gaze_params.ngazes
           if run_flags.load_smap(k)
              smaps(:,:,k)=double(imread(image_props.output_image_paths{k})); 
           else
              %we have already computed the smaps(k) on previous loop
           end
        end
        
        if conf_struct.gaze_params.ngazes ==1
        
            mean_smap = smaps(:,:,1);
            imwrite(mean_smap,[image_props.output_mean_path]);
            
        elseif conf_struct.gaze_params.ngazes ==2
            part = 2:2; %all gazes except first
            mean_smap = get_smaps_mean(smaps,part);
            imwrite(mean_smap,[image_props.output_mean_path_nobaseline]);

            part = 1:2; %all gazes
            mean_smap = get_smaps_mean(smaps,part);
            imwrite(mean_smap,[image_props.output_mean_path]);
        else
            
            part = 1:3; %first 2 gazes
            mean_smap = get_smaps_mean(smaps,part);
            imwrite(mean_smap,[image_props.output_mean_path_first2]);

            part = 2:3; %first 2 gazes except first
            mean_smap = get_smaps_mean(smaps,part);
            imwrite(mean_smap,[image_props.output_mean_path_first2_nobaseline]);

            part = 2:round(conf_struct.gaze_params.ngazes)*1; %all gazes except first
            mean_smap = get_smaps_mean(smaps,part);
            imwrite(mean_smap,[image_props.output_mean_path_nobaseline]);

            part = 1:round(conf_struct.gaze_params.ngazes)*1; %all gazes
            mean_smap = get_smaps_mean(smaps,part);
            imwrite(mean_smap,[image_props.output_mean_path]);
    
        end
        
        imwrite(mean_smap,[image_props.output_image_path]);
        
        
    else
         mean_smap = imread(image_props.output_mean_path); 
        
    end
end
function [gaussian_smap] = run_gaussian(run_flags,image_props,conf_struct,scanpath)
    if run_flags.run_gaussian
        
        if conf_struct.gaze_params.ngazes <=1
            aux_scanpath = scanpath(2:2,:); %all gazes except first
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path_nobaseline]);

            aux_scanpath = scanpath(1:2,:); %all gazes
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path]);
        else
            
            aux_scanpath = scanpath(1:3,:); %first 2 gazes
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path_first2]);

            aux_scanpath = scanpath(2:3,:); %first 2 gazes except first
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path_first2_nobaseline]);

            aux_scanpath = scanpath(2:round(conf_struct.gaze_params.ngazes)*1,:); %all gazes except first
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path_nobaseline]);

            aux_scanpath = scanpath(:,:); %all gazes
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path]);
        end
        
    else
       gaussian_smap = imread(image_props.output_gaussian_path); 
    end
end

function [bmap] = run_bmap(run_flags,image_props,conf_struct,scanpath)
    if run_flags.run_bmap
        
        if conf_struct.gaze_params.ngazes <=1
            aux_scanpath = scanpath(2:2,:); %all gazes except first
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path_nobaseline]);

            aux_scanpath = scanpath(1:2,:); %all gazes
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path]);
        else
            
            aux_scanpath = scanpath(1:3,:); %first 2 gazes
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path_first2]);

            aux_scanpath = scanpath(2:3,:); %first 2 gazes except first
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path_first2_nobaseline]);

            aux_scanpath = scanpath(2:round(conf_struct.gaze_params.ngazes)*1,:); %all gazes except first
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path_nobaseline]);

            aux_scanpath = scanpath(:,:); %all gazes
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path]);
        end
        
    else
       bmap = imread(image_props.output_bmap_path); 
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB_PROCEDURES

function [scanpath] = get_scanpath(smaps,conf_struct)

        scanpath(1,2) = round(conf_struct.gaze_params.orig_height/2);
        scanpath(1,1) = round(conf_struct.gaze_params.orig_width/2);
           
        for k=1:conf_struct.gaze_params.ngazes
            smap = smaps(:,:,k);
            [maxval, maxidx] = max(smap(:));
            [conf_struct.gaze_params.fov_y, conf_struct.gaze_params.fov_x] = ind2sub(size(smap),maxidx); %x,y
                %cuidado con el size(smap), tiene que ser fov de imagen original
            scanpath(k+1,2) = conf_struct.gaze_params.fov_y;
            scanpath(k+1,1) = conf_struct.gaze_params.fov_x;
        end
    
end

function [mean_smap] = get_smaps_mean(smaps,part)
    if ~exist('part','var') part = size(smaps,3); end
    
    smaps_part = smaps(:,:,part);
    
    mean_smap = normalize_minmax(mean(smaps_part,3));  
    
end

function [gaussian_smap] = get_smaps_gaussian(scanpath,conf_struct)
    bmap = scanpath2bmap(scanpath, size(scanpath,1),[conf_struct.gaze_params.orig_height conf_struct.gaze_params.orig_width]);
    gaussian_smap = bmap2gaussian(bmap);
    gaussian_smap = normalize_minmax(gaussian_smap);   
    
end


function [bmap] = get_smaps_bmap(scanpath,conf_struct)
    bmap = scanpath2bmap(scanpath, size(scanpath,1),[conf_struct.gaze_params.orig_height conf_struct.gaze_params.orig_width]);
  
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% UTILS FOR RUNNING MAIN

function [folder_props] = get_folder_properties(output_folder,conf_struct_path_name,output_folder_mats,output_extension)
    %get folder properties
    folder_props.output_folder = output_folder ;
    folder_props.output_subfolder = conf_struct_path_name ;
    
    folder_props.output_path = [folder_props.output_folder '/' folder_props.output_subfolder];
    folder_props.output_folder_mats = output_folder_mats ;
    folder_props.output_extension = output_extension ;
    folder_props.output_folder_scanpath = [ folder_props.output_path '/' 'scanpath'];
    
    folder_props.output_folder_mean = [ folder_props.output_folder_scanpath '/' 'mean' '_' folder_props.output_subfolder];
    folder_props.output_folder_mean_first2 = [ folder_props.output_folder_scanpath '/' 'mean_first2' '_' folder_props.output_subfolder];
    folder_props.output_folder_mean_first2_nobaseline = [ folder_props.output_folder_scanpath '/' 'mean_first2_nobaseline' '_' folder_props.output_subfolder];
    folder_props.output_folder_mean_nobaseline = [ folder_props.output_folder_scanpath '/' 'mean_nobaseline' '_' folder_props.output_subfolder];
    folder_props.output_folder_gaussian = [ folder_props.output_folder_scanpath '/' 'gaussian' '_' folder_props.output_subfolder];
    folder_props.output_folder_gaussian_first2 = [ folder_props.output_folder_scanpath '/' 'gaussian_first2' '_' folder_props.output_subfolder];
    folder_props.output_folder_gaussian_first2_nobaseline = [ folder_props.output_folder_scanpath '/' 'gaussian_first2_nobaseline' '_' folder_props.output_subfolder];
    folder_props.output_folder_gaussian_nobaseline = [ folder_props.output_folder_scanpath '/' 'gaussian_nobaseline' '_' folder_props.output_subfolder];
    folder_props.output_folder_bmap = [ folder_props.output_folder_scanpath '/' 'bmap' '_' folder_props.output_subfolder];
    folder_props.output_folder_bmap_first2 = [ folder_props.output_folder_scanpath '/' 'bmap_first2' '_' folder_props.output_subfolder];
    folder_props.output_folder_bmap_first2_nobaseline = [ folder_props.output_folder_scanpath '/' 'bmap_first2_nobaseline' '_' folder_props.output_subfolder];
    folder_props.output_folder_bmap_nobaseline = [ folder_props.output_folder_scanpath '/' 'bmap_nobaseline' '_' folder_props.output_subfolder];
    
    if ~exist(folder_props.output_folder,'dir') mkdir(folder_props.output_folder); end
    if ~exist(folder_props.output_path,'dir') mkdir(folder_props.output_path); end
    if ~exist(folder_props.output_folder_mats,'dir') mkdir(folder_props.output_folder_mats); end
    if ~exist(folder_props.output_folder_scanpath,'dir') mkdir(folder_props.output_folder_scanpath); end
    
    if ~exist(folder_props.output_folder_mean,'dir') mkdir(folder_props.output_folder_mean); end
    if ~exist(folder_props.output_folder_mean_first2,'dir') mkdir(folder_props.output_folder_mean_first2); end
    if ~exist(folder_props.output_folder_mean_first2_nobaseline,'dir') mkdir(folder_props.output_folder_mean_first2_nobaseline); end
    if ~exist(folder_props.output_folder_mean_nobaseline,'dir') mkdir(folder_props.output_folder_mean_nobaseline); end
    if ~exist(folder_props.output_folder_gaussian,'dir') mkdir(folder_props.output_folder_gaussian); end
    if ~exist(folder_props.output_folder_gaussian_first2,'dir') mkdir(folder_props.output_folder_gaussian_first2); end
    if ~exist(folder_props.output_folder_gaussian_first2_nobaseline,'dir') mkdir(folder_props.output_folder_gaussian_first2_nobaseline); end
    if ~exist(folder_props.output_folder_gaussian_nobaseline,'dir') mkdir(folder_props.output_folder_gaussian_nobaseline); end
    if ~exist(folder_props.output_folder_bmap,'dir') mkdir(folder_props.output_folder_bmap); end
    if ~exist(folder_props.output_folder_bmap_first2,'dir') mkdir(folder_props.output_folder_bmap_first2); end
    if ~exist(folder_props.output_folder_bmap_first2_nobaseline,'dir') mkdir(folder_props.output_folder_bmap_first2_nobaseline); end
    if ~exist(folder_props.output_folder_bmap_nobaseline,'dir') mkdir(folder_props.output_folder_bmap_nobaseline); end

end

function [image_props] = get_image_properties(input_image,image_name,folder_props,conf_struct)
    %get image properties
    image_props.input_image = input_image;
    image_props.image_name = image_name;
    image_props.image_name_noext = remove_extension(image_props.image_name);
    image_props.output_image_path= [folder_props.output_path '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_scanpath_path= [ folder_props.output_folder_scanpath '/' image_props.image_name_noext '.mat' ];
    
    image_props.output_image_paths = cell(1,conf_struct.gaze_params.ngazes);
    for k=1:conf_struct.gaze_params.ngazes
        image_props.output_image_paths{k} = [folder_props.output_path '/' image_props.image_name_noext '_gaze' num2str(k) '.' folder_props.output_extension];
        
    end
    
    image_props.output_mean_path = [folder_props.output_folder_mean '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_mean_path_first2 = [folder_props.output_folder_mean_first2 '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_mean_path_first2_nobaseline = [folder_props.output_folder_mean_first2_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_mean_path_nobaseline = [folder_props.output_folder_mean_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    
    
    image_props.output_gaussian_path = [folder_props.output_folder_gaussian '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_gaussian_path_first2 = [folder_props.output_folder_gaussian_first2 '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_gaussian_path_first2_nobaseline = [folder_props.output_folder_gaussian_first2_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_gaussian_path_nobaseline = [folder_props.output_folder_gaussian_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    
    image_props.output_bmap_path = [folder_props.output_folder_bmap '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_bmap_path_first2 = [folder_props.output_folder_bmap_first2 '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_bmap_path_first2_nobaseline = [folder_props.output_folder_bmap_first2_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    image_props.output_bmap_path_nobaseline = [folder_props.output_folder_bmap_nobaseline '/' image_props.image_name_noext '.' folder_props.output_extension];
    

end

function [mat_props] = get_mat_properties(folder_props,image_props,conf_struct)

    mat_props.loaded_struct_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op1_iFactor_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op2_iFactor_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op3_iFactor_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op1_WavCurv_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op2_WavCurv_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op3_WavCurv_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op1_WavResidual_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op2_WavResidual_path = cell(1,conf_struct.gaze_params.ngazes);
    mat_props.op3_WavResidual_path = cell(1,conf_struct.gaze_params.ngazes);
    
    
    
    for k=1:conf_struct.gaze_params.ngazes
        
        mat_props.loaded_struct_path{k} = get_mat_name('struct',folder_props,image_props,k);
        
        mat_props.op1_iFactor_path{k} = get_mat_name('iFactor',folder_props,image_props,k,'chromatic');
        mat_props.op2_iFactor_path{k} = get_mat_name('iFactor',folder_props,image_props,k,'chromatic2');
        mat_props.op3_iFactor_path{k} = get_mat_name('iFactor',folder_props,image_props,k,'intensity');
        
        mat_props.op1_WavCurv_path{k} = get_mat_name('w',folder_props,image_props,k,'chromatic');
        mat_props.op2_WavCurv_path{k} = get_mat_name('w',folder_props,image_props,k,'chromatic2');
        mat_props.op3_WavCurv_path{k} = get_mat_name('w',folder_props,image_props,k,'intensity');
        
        mat_props.op1_WavResidual_path{k} = get_mat_name('c',folder_props,image_props,k,'chromatic');
        mat_props.op2_WavResidual_path{k} = get_mat_name('c',folder_props,image_props,k,'chromatic2');
        mat_props.op3_WavResidual_path{k} = get_mat_name('c',folder_props,image_props,k,'intensity');
        
        
    end
end

function [run_flags] = get_run_flags(image_props,mat_props,conf_struct)

    
    
    for k=1:conf_struct.gaze_params.ngazes
       run_flags.run_smaps = 0;
       if exist(image_props.output_image_paths{k},'file')==0
           run_flags.load_smap(k)=0;
           run_flags.run_smaps = 1;
       else
           
           run_flags.load_smap(k)=1;
       end
    end
    
    if exist(image_props.output_image_path, 'file') 
        run_flags.run_smap = 0;
     else
        run_flags.run_smap = 1;
    end
    if exist(image_props.output_gaussian_path, 'file') 
        run_flags.run_gaussian = 0;
     else
        run_flags.run_gaussian = 1;
    end
    if exist(image_props.output_bmap_path, 'file') 
        run_flags.run_bmap = 0;
     else
        run_flags.run_bmap = 1;
    end
    
    if exist(image_props.output_mean_path, 'file') 
        run_flags.run_mean = 0;
     else
        run_flags.run_mean = 1;
    end
    
    if exist(image_props.output_scanpath_path, 'file') 
        run_flags.run_scanpath = 0;
     else
        run_flags.run_scanpath = 1;
    end
    
    if exist(image_props.output_image_path, 'file') ...
            && exist(image_props.output_scanpath_path, 'file') ...
            && exist(image_props.output_mean_path, 'file') ...
            && exist(image_props.output_gaussian_path, 'file') ...
            && exist(image_props.output_bmap_path, 'file') 
        run_flags.run_all = 0;
     else
        run_flags.run_all = 1;
    end
    
     for k=1:conf_struct.gaze_params.ngazes
         
         
         if exist(mat_props.loaded_struct_path{k}, 'file') 
             loaded_struct = load(mat_props.loaded_struct_path{k}); loaded_struct = loaded_struct.matrix_in;
             if compare_structs(conf_struct,loaded_struct) == 1
                 run_flags.load_struct(k)=1;
             else
                 run_flags.load_struct(k)=0;
             end
         else
             run_flags.load_struct(k)=0;
         end
         
         if exist(mat_props.loaded_struct_path{k}, 'file') ...
             && exist(mat_props.op1_iFactor_path{k}, 'file') ...
             && exist(mat_props.op2_iFactor_path{k}, 'file') ...
             && exist(mat_props.op3_iFactor_path{k}, 'file') ...

             run_flags.load_iFactor_mats(k)=1;
         else
             run_flags.load_iFactor_mats(k)=0;
         end
         
         
         if exist(mat_props.loaded_struct_path{k}, 'file') ...
             && exist(mat_props.op1_WavCurv_path{k}, 'file') ...
             && exist(mat_props.op2_WavCurv_path{k}, 'file') ...
             && exist(mat_props.op3_WavCurv_path{k}, 'file')
         
             run_flags.load_WavCurv_mats(k)=1;
         else
             run_flags.load_WavCurv_mats(k)=0;
         end
         
         if  exist(mat_props.loaded_struct_path{k}, 'file') ...
             && exist(mat_props.op1_WavResidual_path{k}, 'file') ...
             && exist(mat_props.op2_WavResidual_path{k}, 'file') ...
             && exist(mat_props.op3_WavResidual_path{k}, 'file')
         
             run_flags.load_WavResidual_mats(k)=1;
         else
             run_flags.load_WavResidual_mats(k)=0;
         end
         
         
     end
    

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% UTILS FILES AND STRUCTS


function [mat_path] = get_mat_name(mat_name,folder_props,image_props,gaze_idx,channel)
    if exist('channel','var') && exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_channel(' channel ')' '_gaze' num2str(gaze_idx) '.mat'];
    elseif exist('channel','var') && ~exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_channel(' channel ')' '.mat'];
    elseif ~exist('channel','var') && exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_gaze' num2str(gaze_idx) '.mat'];
    else
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '.mat'];
    end
end


function [] = save_mat(mat_name,matrix_in,folder_props,image_props,gaze_idx,channel)
    if exist('channel','var') && exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_channel(' channel ')' '_gaze' num2str(gaze_idx) '.mat'];
    elseif exist('channel','var') && ~exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_channel(' channel ')' '.mat'];
    elseif ~exist('channel','var') && exist('gaze_idx','var')
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '_gaze' num2str(gaze_idx) '.mat'];
    else
        mat_path = [ folder_props.output_folder_mats '/' image_props.image_name_noext '_' mat_name '.mat'];
    end
    save(mat_path,'matrix_in');

end



function [veredict] = compare_structs(struct, loaded_struct)

    if  loaded_struct.gaze_params.foveate == struct.gaze_params.foveate  ...  
       && strcmp(loaded_struct.gaze_params.fov_type,struct.gaze_params.fov_type)  ...
       && strcmp(loaded_struct.fusion_params.output_from_model,struct.fusion_params.output_from_model)  ... 
       && loaded_struct.color_params.gamma == struct.color_params.gamma  ... 
       && loaded_struct.color_params.srgb_flag == struct.color_params.srgb_flag  ... 
       && loaded_struct.resize_params.autoresize_ds == struct.resize_params.autoresize_ds  ...
       && loaded_struct.resize_params.autoresize_nd == struct.resize_params.autoresize_nd  ...
       && loaded_struct.compute_params.model == struct.compute_params.model  ... 
       && loaded_struct.zli_params.n_membr == struct.zli_params.n_membr  ...
       && loaded_struct.zli_params.n_iter == struct.zli_params.n_iter  ... 
       && strcmp(loaded_struct.zli_params.dist_type, struct.zli_params.dist_type)  ...
       && loaded_struct.zli_params.scalesize_type == struct.zli_params.scalesize_type  ... 
       && loaded_struct.zli_params.scale2size_type == struct.zli_params.scale2size_type  ... 
       && loaded_struct.zli_params.scale2size_epsilon == struct.zli_params.scale2size_epsilon  ...
       && loaded_struct.zli_params.bScaleDelta == struct.zli_params.bScaleDelta  ... 
       && loaded_struct.zli_params.reduccio_JW == struct.zli_params.reduccio_JW  ... 
       && strcmp(loaded_struct.zli_params.normal_type, struct.zli_params.normal_type)  ... 
       && loaded_struct.zli_params.alphax == struct.zli_params.alphax ... 
       && loaded_struct.zli_params.alphay == struct.zli_params.alphay ... 
       && loaded_struct.zli_params.nb_periods == struct.zli_params.nb_periods ... 
       && loaded_struct.zli_params.normal_input == struct.zli_params.normal_input ...
       && loaded_struct.zli_params.normal_output == struct.zli_params.normal_output ...
       && loaded_struct.zli_params.normal_min_absolute == struct.zli_params.normal_min_absolute ... 
       && loaded_struct.zli_params.normal_max_absolute == struct.zli_params.normal_max_absolute ... 
       && loaded_struct.zli_params.Delta == struct.zli_params.Delta ... 
       && loaded_struct.zli_params.ON_OFF == struct.zli_params.ON_OFF ... 
       && strcmp(loaded_struct.zli_params.boundary,struct.zli_params.boundary) ...
       && loaded_struct.zli_params.normalization_power == struct.zli_params.normalization_power ...
       && loaded_struct.zli_params.kappax == struct.zli_params.kappax ...
       && loaded_struct.zli_params.kappay == struct.zli_params.kappay ...
       && loaded_struct.zli_params.shift == struct.zli_params.shift ...
       && loaded_struct.zli_params.scale_interaction == struct.zli_params.scale_interaction ... 
       && loaded_struct.zli_params.orient_interaction == struct.zli_params.orient_interaction ...
       &&  strcmp(loaded_struct.cortex_params.cm_method,struct.cortex_params.cm_method) ...
       && loaded_struct.cortex_params.a == struct.cortex_params.a ...
       && loaded_struct.cortex_params.b == struct.cortex_params.b ...
       && loaded_struct.cortex_params.lambda == struct.cortex_params.lambda  ... 
       && loaded_struct.cortex_params.cortex_width == struct.cortex_params.cortex_width  ...
       && loaded_struct.cortex_params.isoPolarGrad == struct.cortex_params.isoPolarGrad ...
       && loaded_struct.cortex_params.eccWidth == struct.cortex_params.eccWidth ...
       && loaded_struct.cortex_params.cortex_max_elong_mm == struct.cortex_params.cortex_max_elong_mm ... 
       && loaded_struct.cortex_params.cortex_max_az_mm == struct.cortex_params.cortex_max_az_mm ...
       && loaded_struct.cortex_params.mirroring == struct.cortex_params.mirroring ...
       && loaded_struct.gaze_params.redistort_periter == struct.gaze_params.redistort_periter ...  
       && loaded_struct.gaze_params.fov_x == struct.gaze_params.fov_x  ... 
       && loaded_struct.gaze_params.fov_y == struct.gaze_params.fov_y  ...
       && loaded_struct.gaze_params.orig_width == struct.gaze_params.orig_width  ...
       && loaded_struct.gaze_params.orig_height == struct.gaze_params.orig_height  ...
       && loaded_struct.gaze_params.img_diag_angle == struct.gaze_params.img_diag_angle   
   
        veredict = 1;
    elseif struct.compute_params.model == -1 %when not using model, do not compare
        veredict = 1;
    else
        veredict = 0;
    end
end





