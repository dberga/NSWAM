function [smap,scanpath,smaps] = nswam(input_image,image_path,conf_struct_path,output_folder,output_folder_mats,output_extension)

addpath(genpath('include'));
addpath(genpath('src'));
addpath(genpath('src_mex'));

%%%%%%%%%%%%%%%%%%default arguments (nargin)
if ~exist('output_extension','var')    output_extension = 'png'; end
if ~exist('output_folder','var')    output_folder = 'output'; end
if ~exist('output_folder_mats','var')   output_folder_mats = 'mats'; end
if ~exist('conf_struct_path','var')    conf_struct_path = 'conf'; end


%non modified input_image
aux_input_image = input_image;

%% LOAD/CREATE CONFIG STRUCT PARAMS

[~,conf_struct_path_name,~] = fileparts(conf_struct_path);
if strcmp(conf_struct_path,'')==0
    
    [conf_struct] = load(conf_struct_path); conf_struct = conf_struct.matrix_in;
else
    conf_struct_folder='conf';
    confgen(conf_struct_folder);
    conf_struct_path=[conf_struct_folder '/' 'config_1.mat'];
    [conf_struct] = load(conf_struct_path); conf_struct = conf_struct.matrix_in;
    
end

%discriminate if no foveation
if  conf_struct.gaze_params.foveate == 0
    conf_struct.gaze_params.ngazes = 1;
end
%color or grayscale image
conf_struct.color_params.nchannels = size(input_image,3);
conf_struct.color_params.channels = {'chromatic','chromatic2','intensity'};

%set gaze parameters
conf_struct.gaze_params.orig_height = size(aux_input_image,1);
conf_struct.gaze_params.orig_width = size(aux_input_image,2);
if conf_struct.gaze_params.fov_x == 0 && conf_struct.gaze_params.fov_y == 0
    conf_struct.gaze_params.fov_y =round(conf_struct.gaze_params.orig_height/2); 
    conf_struct.gaze_params.fov_x =round(conf_struct.gaze_params.orig_width/2); 
end

%set inhibition of return at zeros
conf_struct.gaze_params.ior_matrix = zeros(conf_struct.gaze_params.orig_height, conf_struct.gaze_params.orig_width);

 
%folders of mats separate or not? (to avoid overwriting)
%if ~conf_struct.file_params.unique_mats_folder
    output_folder_mats = [output_folder_mats '/' conf_struct_path_name];
%end

%set default old params
if ~isfield(conf_struct.fusion_params,'gsp') conf_struct.fusion_params.gsp = 1; end;
if ~isfield(conf_struct.fusion_params,'ior_smap') conf_struct.fusion_params.ior_smap = 1; end;
if ~isfield(conf_struct.fusion_params,'inverse') conf_struct.fusion_params.inverse = 'multires_inv'; end;
if ~isfield(conf_struct.compute_params,'posttune') conf_struct.compute_params.posttune=0; end

            

%% INITIALIZE OUTPUT
[M,N,C] = size(input_image);
smap = zeros(M,N);
smaps = zeros(M,N,conf_struct.gaze_params.ngazes);
gmaps = zeros(M,N,conf_struct.gaze_params.ngazes);
scanpath = zeros(conf_struct.gaze_params.ngazes+1,2);

iFactors = cell(1,3);
curvs = cell(1,3);
residuals = cell(1,3);
%%%%%%%%%%%%%%%%%%get folder_props and image_props
[folder_props] = get_folder_properties(output_folder,conf_struct_path_name,output_folder_mats,output_extension,conf_struct);
[image_props] = get_image_properties(input_image,image_path,folder_props,conf_struct);
[mat_props] = get_mat_properties(folder_props,image_props,conf_struct);


%%%%%%%%%%%%%%%%%%GET RUN FLAGS (LOAD,NEURODYN,RECONS...)
[run_flags] = get_run_flags(image_props,mat_props,conf_struct);

%% NSWAM ALGORITHM
if run_flags.run_all==1
    if run_flags.run_smaps
        for k=1:conf_struct.gaze_params.ngazes
            disp(['Gaze :' int2str(k)]);
            
            conf_struct.gaze_params.gaze_idx = k-1; %starting at 0
            
            input_image = double(aux_input_image);
                    %get_fig_opp(normalize_minmax(input_image,0,255),'img',folder_props,image_props,conf_struct);
            
            %% 1.im2opponent  [IMAGE->RGC]
            input_image = get_rgb2opp(input_image,conf_struct); %! (depending on flag)
                    %get_fig_opp(input_image,'opp',folder_props,image_props,conf_struct);
            
                    
            
            %% 2 & 3.foveate (or cortical mapping) and DWT [RGC->LGN->CORTEX]
            
            ior_matrix_unfoveated = conf_struct.gaze_params.ior_matrix;    
            
            switch conf_struct.gaze_params.foveate
                case 1 %foveate before DWT
                    [input_image] = get_resize(input_image,conf_struct);
                    [conf_struct.resize_params.M, conf_struct.resize_params.N, ~] = size(input_image);
                    [conf_struct.resize_params.fov_x,conf_struct.resize_params.fov_y] = movecoords( conf_struct.gaze_params.orig_height, conf_struct.gaze_params.orig_width, conf_struct.gaze_params.fov_x, conf_struct.gaze_params.fov_y , conf_struct.resize_params.M, conf_struct.resize_params.N); 
                    
                    [input_image] = get_foveate(input_image,conf_struct);
                    [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(input_image, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
                    [conf_struct.wave_params.n_orient] = calc_norient(input_image,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);            
                    [curvs,residuals] = get_DWT(run_flags,conf_struct,folder_props,image_props,C,k,input_image);
                    conf_struct.gaze_params.ior_matrix = get_foveate(conf_struct.gaze_params.ior_matrix,conf_struct,1);
                    
                case 3 %foveate after DWT
                    [input_image] = get_resize(input_image,conf_struct);
                    [conf_struct.resize_params.M, conf_struct.resize_params.N, ~] = size(input_image);
                    [conf_struct.resize_params.fov_x,conf_struct.resize_params.fov_y] = movecoords( conf_struct.gaze_params.orig_height, conf_struct.gaze_params.orig_width, conf_struct.gaze_params.fov_x, conf_struct.gaze_params.fov_y , conf_struct.resize_params.M, conf_struct.resize_params.N); 
                    
                    [input_image_foveated] = get_foveate(input_image,conf_struct);
                    [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(input_image_foveated, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
                    [conf_struct.wave_params.n_orient] = calc_norient(input_image_foveated,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);            
                    [curvs,residuals] = get_DWT(run_flags,conf_struct,folder_props,image_props,C,k,input_image);
                    [curvs,residuals]=get_foveate_multires(curvs,residuals,conf_struct);
                    conf_struct.gaze_params.ior_matrix = get_foveate(conf_struct.gaze_params.ior_matrix,conf_struct,1);
                    
                otherwise %do not foveate
                    [input_image] = get_resize(input_image,conf_struct);
                    [conf_struct.resize_params.M, conf_struct.resize_params.N, ~] = size(input_image);
                    [conf_struct.resize_params.fov_x,conf_struct.resize_params.fov_y] = movecoords( conf_struct.gaze_params.orig_height, conf_struct.gaze_params.orig_width, conf_struct.gaze_params.fov_x, conf_struct.gaze_params.fov_y , conf_struct.resize_params.M, conf_struct.resize_params.N); 
                    
                    [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(input_image, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
                    [conf_struct.wave_params.n_orient] = calc_norient(input_image,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);            
                    [curvs,residuals] = get_DWT(run_flags,conf_struct,folder_props,image_props,C,k,input_image);
                    [conf_struct.gaze_params.ior_matrix] = get_resize(conf_struct.gaze_params.ior_matrix,conf_struct);
            end
            
            %get_fig_opp(input_image,'fov',folder_props,image_props,conf_struct);
            %get_fig_wav(curvs_aux{1},'wav_c1',folder_props,image_props,conf_struct);
            %get_fig_wav(curvs_aux{2},'wav_c2',folder_props,image_props,conf_struct);
            %get_fig_wav(curvs_aux{3},'wav_c3',folder_props,image_props,conf_struct);
            
            [loaded_struct,conf_struct] = get_loaded_struct(run_flags,folder_props,image_props,mat_props,conf_struct,k);
            
             
            %% 4. CORE, COMPUTE DYNAMICS [CORTEX->CORTEX]
            [iFactors] = get_dynamics(run_flags,loaded_struct,folder_props,image_props,C,k,curvs,residuals);
                    %get_fig_ifactor(iFactors{1},'ifactor_c1',folder_props,image_props,conf_struct);
                    %get_fig_ifactor(iFactors{2},'ifactor_c2',folder_props,image_props,conf_struct);
                    %get_fig_ifactor(iFactors{3},'ifactor_c3',folder_props,image_props,conf_struct);
                    %get_fig_ifactor_activity(iFactors{1},'ifactor_c1',folder_props,image_props,conf_struct);
                    %get_fig_ifactor_activity(iFactors{2},'ifactor_c2',folder_props,image_props,conf_struct);
                    %get_fig_ifactor_activity(iFactors{3},'ifactor_c3',folder_props,image_props,conf_struct);
                    
            if isempty(iFactors)
                return;
            end
            
            %% 5. FUSION [CORTEX->SMAP]

            %residual to zero?
            [residuals{1}] = get_residual_updated(loaded_struct,residuals{1});
            [residuals{2}] = get_residual_updated(loaded_struct,residuals{2});
            [residuals{3}] = get_residual_updated(loaded_struct,residuals{3});
            
            residual_s_c = cs2sc(residuals,3,loaded_struct.wave_params.n_scales);
            
            %change its cell dimensions back to its format
            RF_ti_s_o_c = unify_channels_ti(iFactors{1},iFactors{2},iFactors{3},loaded_struct);
                %residual_c_s = unify_channels_norient(residuals{1},residuals{2},residuals{3},loaded_struct);

            %temporal mean for RF
            RF_s_o_c = timatrix_to_matrix(RF_ti_s_o_c,loaded_struct);

            %eCSF  (depending on flag)
            [RF_s_o_c] = get_eCSF(loaded_struct,RF_s_o_c);
            
            %fusion
            if isnan(RF_s_o_c{1}{1}(1,1,1))
                break;
            end
            [smap,residualmax,maxidx_s, maxidx_o, maxidx_c, maxidx_x, maxidx_y ] = get_fusion(RF_s_o_c, residual_s_c,loaded_struct);
            [maxval_d,maxidx_d]=max(smap(:));
            [maxval_r,maxidx_r]=max(residualmax(:));
            if maxidx_c>C, maxidx_c=C; end; 
            conf_struct.gaze_params.maxidx_s=maxidx_s;
            conf_struct.gaze_params.maxidx_o=maxidx_o;
            conf_struct.gaze_params.maxidx_c=maxidx_c; 
            conf_struct.gaze_params.maxidx_x=maxidx_x;
            conf_struct.gaze_params.maxidx_y=maxidx_y;
            
            %undistort
            smap = get_undistort(loaded_struct,smap);
                
            %deresize to original size
            smap = get_deresize(loaded_struct,smap);
            [maxval,maxidx]=max(smap(:));
            
            %update fov_x and fov_y
            [conf_struct.gaze_params.fov_y, conf_struct.gaze_params.fov_x] = ind2sub([conf_struct.gaze_params.orig_height conf_struct.gaze_params.orig_width],maxidx);
            [conf_struct.resize_params.fov_y, conf_struct.resize_params.fov_x] = ind2sub([conf_struct.resize_params.M conf_struct.resize_params.N],maxidx_d);
            
            
            %set inhibition of return on current gaze (update and add)
            conf_struct.gaze_params.ior_matrix = get_ior_matrix_newgaze(ior_matrix_unfoveated, maxidx_s,conf_struct.wave_params.ini_scale,conf_struct.wave_params.fin_scale,conf_struct); 
                %get_fig_single(normalize_minmax(conf_struct.gaze_params.ior_matrix,0,1),'ior',folder_props,image_props,conf_struct);
            
            %set ior smap (depending on a fusion factor)
            gmap=get_ior_gaussian(conf_struct.gaze_params.fov_x, conf_struct.gaze_params.fov_y, 1, maxidx_s,conf_struct.wave_params.ini_scale,conf_struct.wave_params.fin_scale, conf_struct.gaze_params.orig_height, conf_struct.gaze_params.orig_width, conf_struct.gaze_params.img_diag_angle);
            
            %normalize
            smap = get_normalize(loaded_struct,smap);
            
            %set smooth smap (depending on a fusion factor)
            smap=get_smooth(smap,conf_struct);
            
            %save
            imwrite(smap, image_props.output_image_paths{k});

            %delete files
            run_delete_files(folder_props,image_props,loaded_struct,k);
            
            
            %iterate
            smaps(:,:,k) = smap;
            gmaps(:,:,k) = gmap;
        end
    end
    
    %% Prepare Output (we just created smaps)
    %smap from means of gazed smaps
    mean_smap = run_mean(run_flags,image_props,conf_struct,smaps);
    
    smap = mean_smap;
    
    %scanpath from files or from computed smaps(k)
    scanpath = run_scanpath(run_flags,image_props,conf_struct,smaps);
    
    %binary map from scanpath
    saccades_bmap = run_bmap(run_flags,image_props,conf_struct,scanpath);
    
    %smap from density of scanpath
    if conf_struct.fusion_params.ior_smap
        mean_gmap = run_gmean(run_flags,image_props,conf_struct,gmaps);
    else
        mean_gmap = run_gaussian(run_flags,image_props,conf_struct,scanpath);
    end
    
   
    
    
else
    %% Prepare Output (we already have smaps)
    smap = imread(image_props.output_image_path); 
    scanpath = load(image_props.output_scanpath_path); scanpath = scanpath.scanpath;
    for k=1:conf_struct.gaze_params.ngazes
       if exist(image_props.output_image_paths{k},'file')
          smaps(:,:,k)=mat2gray(imread(image_props.output_image_paths{k})); 
       else
          imwrite(smaps(:,:,k),image_props.output_image_paths{k});
       end
    end
    
end

end





