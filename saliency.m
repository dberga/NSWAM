
function [] = saliency(input_image,image_name,conf_struct_path,output_folder,output_folder_mats,output_folder_figs,output_extension)


clear struct wave zli display_plot compute 

if nargin < 7
output_folder = 'output';
output_folder_mats = 'mats'; %output_folder_mats = [output_path 'output_mats'];
output_folder_figs = 'figs'; %output_folder_figs = [output_path 'output_figs'];
output_extension = '.png';

if nargin < 3
	conf_struct_path = 'default_struct.mat';
end

end


[conf_struct_path_folder,conf_struct_path_name,conf_struct_path_ext] = fileparts(conf_struct_path);


%set path parameters
output_prefix = '';

output_subfolder = conf_struct_path_name ;
output_path = [output_folder '/' output_subfolder '/'];
output_folder_imgs = output_path; %output_folder_imgs = [output_path 'output_imgs'];
image_name_noext = remove_extension(image_name);
output_image = [output_prefix image_name_noext];
experiment_name =  image_name_noext;
output_image_path= [output_folder_imgs '/' output_image output_extension];

channels = {'chromatic', 'chromatic2' ,'intensity'};
image_struct_path = [ output_folder_mats '/' image_name_noext '_' 'struct' '.mat'];
c1_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{1} ')' '.mat'];
c2_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{2} ')' '.mat'];
c3_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{3} ')' '.mat'];
c1_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{1} ')' '.mat'];
c2_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{2} ')' '.mat'];
c3_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{3} ')' '.mat'];
c1_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{1} ')' '.mat'];
c2_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{2} ')' '.mat'];
c3_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{3} ')' '.mat'];


if exist(output_image_path, 'file')
	
	%do nothing
	disp([image_name_noext ' already exists']);
    
else
    
%struct params
conf_struct = load(conf_struct_path);
conf_struct = conf_struct.matrix_in;
ds_res = conf_struct.image.autoresize_ds;
nd_res = conf_struct.image.autoresize_nd;
fovear = conf_struct.image.foveate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Load parameters %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%struct=get_default_parameters_NCZLd();
struct=load_default_parameters_NCZLd(conf_struct_path);

struct.image.M = size(input_image,1);
struct.image.N = size(input_image,2);
struct.image.fov_type = 'zli_foveal_distortion';
struct.image.fixationY = round(size(input_image,1)/2);
struct.image.fixationX = round(size(input_image,2)/2);
struct.image.single = experiment_name;
[struct.image.name] = experiment_name;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Calc scales and orient %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %if n_scales = 0
        [struct.wave.n_scales, struct.wave.ini_scale, struct.wave.fin_scale]= calc_scales(input_image, struct.wave.ini_scale, struct.wave.fin_scale_offset, struct.wave.mida_min, struct.wave.multires); % calculate number of scales (n_scales) automatically

        [struct.wave.n_orient] = calc_norient(input_image,struct.wave.multires,struct.wave.n_scales,struct.zli.n_membr);
        devlog(strcat('Nombre scales a la funci channel_v1_0: ', num2str(struct.wave.n_scales)));
        
        

%resize if necessary
if ds_res ~= -1    
    input_image = autoresize(input_image,ds_res);
else
    input_image = autoresize(input_image);
end

if nd_res ~= 0
    input_image = autoresize_nd(input_image,conf_struct,nd_res);
end

%if image is monochromatic, copy channels (cuidado! mejor solo hacer 1)
if(size(input_image,3)<3)
        input_image(:,:,2) = input_image(:,:,1);
        input_image(:,:,3) = input_image(:,:,1);
end

%foveate function
if fovear == 1
    input_image = foveate(input_image,0,conf_struct);
end
    




mkdir(output_folder_imgs);
mkdir(output_folder_mats);
mkdir(output_folder_figs);




	if exist(image_struct_path, 'file') && exist(c1_iFactorpath, 'file') && exist(c2_iFactorpath, 'file') && exist(c3_iFactorpath, 'file') && exist(c1_residualpath, 'file') && exist(c2_residualpath, 'file') && exist(c3_residualpath, 'file') && exist(c1_Lspath, 'file') && exist(c2_Lspath, 'file') && exist(c3_Lspath, 'file')
		
        %do nothing, recall afterwards
  
        
		
    else
        
        disp([image_name_noext ' pre neurodynamical process ']);
        
        input_image = double(input_image);
        devlog(int2str(size(input_image(:,:,1))) );
        
        


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Plot and store  struct %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        store_matrix_givenparams(struct,'struct',struct);

        
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %%%%%%%  stimulus (image) to opponent
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        input_image = get_the_cstimulus(input_image,struct.image.gamma,struct.image.srgb_flag);%! color  to opponent



        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%% Apply neurodynamical %%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        channels={'chromatic', 'chromatic2', 'intensity'};
        for op=1:3

            channel = channels{op};
            im_opponent = input_image(:,:,op);

            im_opponent_dynamic = dynrep_channel(im_opponent,struct.zli.n_membr); %if static, replicate frames

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% wavelet decomposition %%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            [curv, w, c, Ls] = multires_dispatcher(im_opponent_dynamic, struct.wave.multires,struct.wave.n_scales, struct.zli.n_membr);

            [curv] = dyncopy_curv(curv,struct.wave.n_scales,struct.zli.n_membr); %! duplicitat, s'hauria de fer a NCZLd


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% store dwt (curv) %%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            if struct.image.tmem_rw_res == 1
            if struct.display_plot.store_irrelevant==1
            %store_matrix_givenparams_channel(curv,'omega',channel,struct);
            store_matrix_givenparams_channel(curv,'omega',channel,struct);
            end
            end
            store_matrix_givenparams_channel(c,'residual',channel,struct);
            store_matrix_givenparams_channel(Ls,'Ls',channel,struct);

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% apply neurodinamic %%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            t_ini=tic;
            disp([image_name_noext ' neurodynamical process on channel: ' channel]);
            
            [curv_final, curv_ON_final, curv_OFF_final, iFactor_ON, iFactor_OFF] =NCZLd_channel_ON_OFF_v1_1(curv,struct,channel);
            iFactor = curv_final;

            toc(t_ini);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% store iFactor %%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            store_matrix_givenparams_channel(iFactor,'iFactor',channel,struct);

            if struct.image.tmem_rw_res == 1
                iFactor_meanized = tmatrix_to_matrix(iFactor,struct,1);
                display_matrix_channel(iFactor_meanized,'iFactor_res',channel,struct);
                store_matrix_givenparams_channel(iFactor_meanized,'iFactor',channel,struct);
            end
        end

    end
    disp([image_name_noext ' post-neurodynamical process']);
    
    %esto deberia ir en la primera parte del if, usar iFactor, c y Ls
    
  
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% load stored struct (mats loaded in that way) %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %struct=get_default_parameters_NCZLd();
    %image_struct=load_default_parameters_NCZLd(img_struct_path);
    
    image_struct = load(image_struct_path); image_struct = image_struct.matrix_in;
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% use compute params as config struct params (post-neurodym parameters) %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    image_struct.compute = struct.compute;
	
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% load stored mats %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


     %load matrixes
    
    c1_iFactor = load(c1_iFactorpath); c1_iFactor = c1_iFactor.matrix_in; 
    c1_residual = load(c1_residualpath); c1_residual = c1_residual.matrix_in;
    c1_Ls = load(c1_Lspath); c1_Ls = c1_Ls.matrix_in;
    c2_iFactor = load(c2_iFactorpath); c2_iFactor = c2_iFactor.matrix_in; 
    c2_residual = load(c2_residualpath); c2_residual = c2_residual.matrix_in;
    c2_Ls = load(c2_Lspath); c2_Ls = c2_Ls.matrix_in;
    c3_iFactor = load(c3_iFactorpath); c3_iFactor = c3_iFactor.matrix_in; 
    c3_residual = load(c3_residualpath); c3_residual = c3_residual.matrix_in;
    c3_Ls = load(c3_Lspath); c3_Ls = c3_Ls.matrix_in;
    
    c1_iFactor =  c1_iFactor(~cellfun('isempty',c1_iFactor));
    c2_iFactor =  c2_iFactor(~cellfun('isempty',c2_iFactor));
    c3_iFactor =  c3_iFactor(~cellfun('isempty',c3_iFactor));
    %c1_Ls =  c1_Ls(~cellfun('isempty',c1_Ls));
    %c2_Ls =  c2_Ls(~cellfun('isempty',c2_Ls));
    %c3_Ls =  c3_Ls(~cellfun('isempty',c3_Ls));
    c1_residual =  c1_residual(~cellfun('isempty',c1_residual));
    c2_residual =  c2_residual(~cellfun('isempty',c2_residual));
    c3_residual =  c3_residual(~cellfun('isempty',c3_residual));
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%residual forced to zero %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    if image_struct.compute.output_from_residu == 0
        for s=1:image_struct.wave.n_scales-1
            c1_residual{s} = zeros(size(c1_residual{s}));
            c2_residual{s} = zeros(size(c2_residual{s}));
            c3_residual{s} = zeros(size(c3_residual{s}));
        end
        if image_struct.image.tmem_rw_res == 0
         for ff=1:image_struct.zli.n_membr
             c1_iFactor{ff}{image_struct.wave.n_scales}{1} = zeros(size(c1_iFactor{ff}{image_struct.wave.n_scales}{1}));
             c2_iFactor{ff}{image_struct.wave.n_scales}{1} = zeros(size(c2_iFactor{ff}{image_struct.wave.n_scales}{1}));
            c3_iFactor{ff}{image_struct.wave.n_scales}{1} = zeros(size(c3_iFactor{ff}{image_struct.wave.n_scales}{1}));
         end
        else
         c1_iFactor{image_struct.wave.n_scales}{1} = zeros(size(c1_iFactor{image_struct.wave.n_scales}{1}));
         c2_iFactor{image_struct.wave.n_scales}{1} = zeros(size(c2_iFactor{image_struct.wave.n_scales}{1}));
         c3_iFactor{image_struct.wave.n_scales}{1} = zeros(size(c3_iFactor{image_struct.wave.n_scales}{1}));
        end
        
    end
    
    %if Ls has no rows/cols (not correct transform)
    if size(c1_Ls,1)~= image_struct.wave.n_scales || size(c2_Ls,3)~= image_struct.wave.n_scales || size(c3_Ls,3)~= image_struct.wave.n_scales
        c1_Ls = c1_residual;
        c2_Ls = c2_residual;
        c3_Ls = c3_residual;
    end
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%saved mats are saved per tmem (ex. from 1 to 10) or already meanized? %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if image_struct.image.tmem_rw_res == 0
	    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%unified RF cells %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        RF_t_s_o_c = unify_channels_t(c1_iFactor,c2_iFactor,c3_iFactor,image_struct);
        
        residual_s_c = unify_channels_norient(c1_residual,c2_residual,c3_residual,image_struct);
        
        Ls_s_c = unify_channels_norient(c1_Ls,c2_Ls,c3_Ls,image_struct);
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%recons function %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
		smap = RF_to_smap(RF_t_s_o_c,residual_s_c,Ls_s_c,image_struct);

    
    else

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%unified RF cells %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        RF_s_o_c = unify_channels(c1_iFactor,c2_iFactor,c3_iFactor,image_struct);
        
        residual_s_c = unify_channels_norient(c1_residual,c2_residual,c3_residual,image_struct);
        
        
        Ls_s_c = unify_channels_norient(c1_Ls,c2_Ls,c3_Ls,image_struct);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%recons function %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    
		smap = RF_to_smap_t(RF_s_o_c,residual_s_c,Ls_s_c,image_struct);

		

    end
    
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%write image %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imwrite(smap,[output_image_path]);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%delete mats or not? %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    delete_files = image_struct.compute.delete_mats; %delete mats after creating imgs (0=no, 1=yes)
	if delete_files == 1
	    
	    delete(c1_residualpath);
	    delete(c1_Lspath);
	    delete(c1_iFactorpath);
	    delete(c2_residualpath);
	    delete(c2_Lspath);
	    delete(c2_iFactorpath);
	    delete(c3_residualpath);
	    delete(c3_Lspath);
	    delete(c3_iFactorpath);

	    %delete(c1_eCSFpath);
            %delete(c2_eCSFpath);
	    %delete(c3_eCSFpath);
	end

	
end

end

