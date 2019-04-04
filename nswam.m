function [smap,scanpath,smaps] = nswam(input_image,image_path,conf_struct_path,output_folder,output_folder_mats,output_extension)

addpath(genpath('include'));
addpath(genpath('src'));
addpath(genpath('src_mex'));

%%%%%%%%%%%%%%%%%%default arguments (nargin)
if ~exist('output_extension','var')    output_extension = 'png'; end
if ~exist('output_folder','var')    output_folder = 'output'; end
if ~exist('output_folder_mats','var')   output_folder_mats = 'mats'; end
if ~exist('conf_struct_path','var')    conf_struct_path = 'conf/single'; end


%non modified input_image
aux_input_image = input_image;

%% LOAD/CREATE CONFIG STRUCT PARAMS

[~,conf_struct_path_name,~] = fileparts(conf_struct_path);
if strcmp(conf_struct_path,'')==0
    
    [conf_struct] = load(conf_struct_path); conf_struct = conf_struct.matrix_in;
else
    conf_struct_folder='conf/single';
    confgen(conf_struct_folder);
    conf_struct_path=[conf_struct_folder '/' 'single_config_b1_15.mat'];
    [conf_struct] = load(conf_struct_path); conf_struct = conf_struct.matrix_in;
end

%discriminate if no foveation
if ~isfield(conf_struct,'gaze_params')
    conf_struct.gaze_params=struct();
    conf_struct.gaze_params.foveate=0;
    conf_struct.gaze_params.fov_x=0;
    conf_struct.gaze_params.fov_y=0;
end
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

%set initial inhibition of return at zeros
ior_matrix_unfoveated = zeros(conf_struct.gaze_params.orig_height, conf_struct.gaze_params.orig_width);
conf_struct.gaze_params.ior_multidim_set=0;

%set topdown params
topdown_matrix_unfoveated = zeros(conf_struct.gaze_params.orig_height, conf_struct.gaze_params.orig_width);
if ~isfield(conf_struct,'search_params')
    conf_struct.search_params=struct(); 
    conf_struct.search_params.topdown=0;
end

%folders of mats separate or not? (to avoid overwriting)
%if ~conf_struct.file_params.unique_mats_folder
    output_folder_mats = [output_folder_mats '/' conf_struct_path_name];
%end

            
%% INITIALIZE OUTPUT
[M,N,C] = size(input_image);
smap = zeros(M,N);
smaps = zeros(M,N,conf_struct.gaze_params.ngazes);
gmaps = zeros(M,N,conf_struct.gaze_params.ngazes);
scanpath = zeros(conf_struct.gaze_params.ngazes+1,2);

iFactors = cell(1,3);
curvs = cell(1,3);
residuals = cell(1,3);

%% %%%%%%%%%%%%%%%%get folder_props and image_props
[folder_props] = get_folder_properties(output_folder,conf_struct_path_name,output_folder_mats,output_extension,conf_struct);
[image_props] = get_image_properties(input_image,image_path,folder_props,conf_struct);
[mat_props] = get_mat_properties(folder_props,image_props,conf_struct);


%% READ SEARCH PARAMETERS (DLPFC)
[ conf_struct ] = generate_topdown( input_image, image_props,conf_struct_path_name,conf_struct );


%% %%%%%%%%%%%%%%%%%%GET RUN FLAGS (LOAD,NEURODYN,RECONS...)
[run_flags] = get_run_flags(image_props,mat_props,conf_struct);



%% NSWAM ALGORITHM
if run_flags.run_all==1
    if run_flags.run_smaps
        for k=1:conf_struct.gaze_params.ngazes
            disp(['Gaze :' int2str(k)]);
            
            conf_struct.gaze_params.gaze_idx = k-1; %starting at 0
            
            %input_image = double(mat2gray(aux_input_image));
                    %get_fig_opp(normalize_minmax(input_image,0,255),'img',folder_props,image_props,conf_struct);
            
            %% 1.im2opponent  [IMAGE->RGC]
            opp_image = get_rgb2opp(input_image,conf_struct); %! (depending on flag)
                    %%plot opponents
                    %get_fig_opp(input_image,'opp',folder_props,image_props,conf_struct);
            
            %% 2. foveate (or cortical mapping) & 3. DWT [RGC->LGN->CORTEX]
              
            switch conf_struct.gaze_params.foveate
                case 1 %foveate before DWT
                    
                    [opp_image_foveated] = get_foveate(opp_image,conf_struct);
                    [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(opp_image_foveated, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
                    [conf_struct.wave_params.n_orient] = calc_norient(opp_image_foveated,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);            
                    [curvs,residuals] = get_DWT(run_flags,conf_struct,folder_props,image_props,C,k,opp_image_foveated);
                    
                    ior_matrix_foveated = get_foveate(ior_matrix_unfoveated,conf_struct,1);
                    topdown_matrix_foveated = get_foveate(topdown_matrix_unfoveated,conf_struct,1);
                    
                    
                case 3 %foveate after DWT
 
                    [opp_image_foveated] = get_foveate(opp_image,conf_struct);
                    [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(opp_image_foveated, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
                    [conf_struct.wave_params.n_orient] = calc_norient(opp_image_foveated,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);            
                    [curvs,residuals] = get_DWT(run_flags,conf_struct,folder_props,image_props,C,k,opp_image);
                    [curvs,residuals]=get_foveate_multires(curvs,residuals,conf_struct);
                    
                    ior_matrix_foveated = get_foveate(ior_matrix_unfoveated,conf_struct,1);
                    topdown_matrix_foveated = get_foveate(topdown_matrix_unfoveated,conf_struct,1);
                    
                otherwise %do not foveate
                    
                    [opp_image] = get_resize(opp_image,conf_struct);
                    %[curvs,residuals]=get_resize_multires(curvs,residuals,conf_struct);
                    [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale,conf_struct.wave_params.fin_scale_offset]= calc_scales(opp_image, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
                    [conf_struct.wave_params.n_orient] = calc_norient(opp_image,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);            
                    [curvs,residuals] = get_DWT(run_flags,conf_struct,folder_props,image_props,C,k,opp_image);
                    
                    [conf_struct.resize_params.M, conf_struct.resize_params.N, ~] = size(get_resize(opp_image,conf_struct)); %size(curvs{1}{1});
                    [conf_struct.resize_params.fov_x,conf_struct.resize_params.fov_y] = movecoords( conf_struct.gaze_params.orig_height, conf_struct.gaze_params.orig_width, conf_struct.gaze_params.fov_x, conf_struct.gaze_params.fov_y , conf_struct.resize_params.M, conf_struct.resize_params.N); 
                    
                    ior_matrix_foveated=get_resize(ior_matrix_unfoveated,conf_struct);
                    topdown_matrix_foveated = get_resize(topdown_matrix_unfoveated,conf_struct);
            end
                %%plot multires
                %get_fig_opp(opp_image,'fov',folder_props,image_props,conf_struct);
                %get_fig_wav(curvs_aux{1},'wav_c1',folder_props,image_props,conf_struct);
                %get_fig_wav(curvs_aux{2},'wav_c2',folder_props,image_props,conf_struct);
                %get_fig_wav(curvs_aux{3},'wav_c3',folder_props,image_props,conf_struct);
            
            %% 4. apply recurrent and/or top-down activity (LIP/FEF & PFC)
            
            %get ior from previous gaze and update according to time
            conf_struct.gaze_params.ior_matrix=ior_matrix_foveated;
            [ conf_struct.gaze_params.ior_matrix_multidim,conf_struct.gaze_params.ior_multidim_set ] = build_ior_multidim( conf_struct, conf_struct.gaze_params.ior_matrix);
            save_mat('ior_matrix_multidim',conf_struct.gaze_params.ior_matrix_multidim,folder_props,image_props,k);
            imwrite(im2uint8(cummax6(conf_struct.gaze_params.ior_matrix_multidim)),[folder_props.output_folder_figs '/' 'ior' '_gaze' num2str(k) '_' image_props.image_name_noext '.png']);
            
            %get topdown / search maps
            conf_struct.search_params.topdown_matrix=topdown_matrix_foveated;
            [ conf_struct.search_params.topdown_matrix_multidim ] = build_topdown_multidim( conf_struct, conf_struct.search_params.topdown_matrix);
            save_mat('topdown_matrix_multidim',conf_struct.search_params.topdown_matrix_multidim,folder_props,image_props,k);
            imwrite(im2uint8(cummax6(conf_struct.search_params.topdown_matrix_multidim)),[folder_props.output_folder_figs '/' 'topdown' '_gaze' num2str(k) '_' image_props.image_name_noext '.png']);
                  
            %save struct gaze config before computing dynamics            
            [loaded_struct,conf_struct] = get_loaded_struct(run_flags,folder_props,image_props,mat_props,conf_struct,k);
            
             
            %% 5. CORE, COMPUTE DYNAMICS [CORTEX->CORTEX]
            [iFactors] = get_dynamics(run_flags,loaded_struct,folder_props,image_props,C,k,curvs,residuals);
            
            if isempty(iFactors)
                return;
            end
            %update nscales according to readed iFactor
            if size(iFactors{1}{1}{1},1) ~= conf_struct.wave_params.fin_scale
                conf_struct.wave_params.ini_scale=1;
                conf_struct.wave_params.fin_scale=size(iFactors{1}{1}{1},1);
                conf_struct.wave_params.n_scales=conf_struct.wave_params.fin_scale+conf_struct.wave_params.fin_scale_offset;
                loaded_struct.wave_params=conf_struct.wave_params;
            end
            
                    %%plot dynamics
                    %get_fig_ifactor(iFactors{1},'ifactor_c1',folder_props,image_props,conf_struct);
                    %get_fig_ifactor(iFactors{2},'ifactor_c2',folder_props,image_props,conf_struct);
                    %get_fig_ifactor(iFactors{3},'ifactor_c3',folder_props,image_props,conf_struct);
                    %get_fig_ifactor_activity(iFactors{1},'ifactor_c1',folder_props,image_props,conf_struct);
                    %get_fig_ifactor_activity(iFactors{2},'ifactor_c2',folder_props,image_props,conf_struct);
                    %get_fig_ifactor_activity(iFactors{3},'ifactor_c3',folder_props,image_props,conf_struct);
                    
            %% 6. FUSION [CORTEX->SMAP]

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
            %number of scales of residual is not equal to RF?
            sd=length(RF_s_o_c)-length(residual_s_c);
            if sd > 0
                for d=1:sd
                    residual_s_c{length(residual_s_c)+1}=residual_s_c{length(residual_s_c)};
                end
            end
            if sd < 0
                for d=1:sd
                    RF_s_o_c{length(RF_s_o_c)+1}=RF_s_o_c{length(RF_s_o_c)};
                end
            end
            %testing all fusion parameters:
                %lstruct=loaded_struct; fusions = {1,2,3,4,5}; smethods={'sqmean','pmax','pmaxc','pmax2','wtamaxc','wtamax2','wta','wta2'}; inverses={'multires_inv','max','wta'}; for fu=1:length(fusions), for sm=1:length(smethods), for in=1:length(inverses), lstruct.fusion_params.fusion = fusions{fu}; lstruct.fusion_params.smethod = smethods{sm}; lstruct.fusion_params.inverse = inverses{in}; figure, imagesc(get_normalize(lstruct,get_undistort(lstruct,get_fusion(RF_s_o_c, residual_s_c,lstruct)))); title(['fusion=' num2str(fusions{fu}) ',smethod=' smethods{sm} ',inverse=' inverses{in}]); end, end, end
                
                
            [smap_RF , ~] = get_fusion(RF_s_o_c, residual_s_c,loaded_struct);
            %[maxval_d,maxidx_d]=max(smap(:));
            %[maxval_r,maxidx_r]=max(residualmax(:));
            
            
            %undistort
            smap = get_undistort(loaded_struct,smap_RF);
            
            %deresize to original size
            smap = get_deresize(loaded_struct,smap);
            %[maxval,maxidx]=max(smap(:));
            
            
            %normalize
            smap = get_normalize(loaded_struct,smap);
            
            %set smooth smap (depending on a fusion factor)
            smap=get_smooth(smap,conf_struct);
            
            %save
            imwrite(smap, image_props.output_image_paths{k});
            %save_mat('struct',conf_struct,folder_props,image_props,gaze_idx);
            
            %delete files
            run_delete_files(folder_props,image_props,loaded_struct,k);
            
            %% GET NEW GAZE
            %get maximum activity and location for new saccade
            [ RFmax_unfov,RFmax,residualmax,max_mempotential_val,fov_y,fov_x,maxidx_y,maxidx_x,maxidx_s,maxidx_o,maxidx_c] = get_maxdims( RF_s_o_c , residual_s_c,loaded_struct);
            conf_struct.gaze_params.maxidx_s=maxidx_s;
            conf_struct.gaze_params.maxidx_o=maxidx_o;
            conf_struct.gaze_params.maxidx_c=maxidx_c;  if maxidx_c>C, maxidx_c=C; end; 
            conf_struct.gaze_params.maxidx_x=maxidx_x;
            conf_struct.gaze_params.maxidx_y=maxidx_y;
            conf_struct.gaze_params.max_mempotential_val = max_mempotential_val; %xon+xoff
            conf_struct.gaze_params.idx_max_mempotential_polarity=1:2; %always ior put on on xon and xoff
            conf_struct.gaze_params.fov_y = fov_y; 
            conf_struct.gaze_params.fov_x = fov_x;
            
            %set inhibition of return on current gaze (update and add)
            ior_matrix_unfoveated = get_ior_gaussian(conf_struct.gaze_params.fov_x, conf_struct.gaze_params.fov_y,conf_struct);
            gmap=ior_matrix_unfoveated;
              %get_fig_single(normalize_minmax(conf_struct.gaze_params.ior_matrix,0,1),'ior',folder_props,image_props,conf_struct);
            
            
            %iterate, save maps per gaze
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
    
    %fixations binary map from scanpath
    bmap = run_bmap(run_flags,image_props,conf_struct,scanpath);
    
    %smap from density of scanpath
    mean_gmap = run_gmean(run_flags,image_props,conf_struct,gmaps); %scale-dependent
    
    
   
    
    
else
    %% Prepare Output (when we already have smaps)
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

%get_fig_scanpath( input_image, 'scanpath', folder_props,image_props, conf_struct );

end





