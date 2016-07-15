
function [] = saliency(input_image,image_name,conf_struct_path,output_folder,output_folder_mats,output_folder_figs,output_extension)

clear struct wave zli display_plot compute matrix_in conf_struct image_struct

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
scanpath_prefix_mat = 'scanpath_';
scanpath_prefix_img = 'scanpath_';
nscans = 5;

output_subfolder = conf_struct_path_name ;
output_path = [output_folder '/' output_subfolder '/'];
output_folder_imgs = output_path; %output_folder_imgs = [output_path 'output_imgs'];
image_name_noext = remove_extension(image_name);
output_image = [output_prefix image_name_noext];
experiment_name =  image_name_noext;
output_image_path= [output_folder_imgs '/' output_image output_extension];
output_scanpath_path= [ output_folder_imgs '/' scanpath_prefix_mat output_image];
scanpath = zeros(nscans,2);


channels = {'chromatic', 'chromatic2' ,'intensity'};
image_struct_path = [ output_folder_mats '/' image_name_noext '_' 'struct' '.mat'];
c1_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{1} ')' '.mat'];
c2_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{2} ')' '.mat'];
c3_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{3} ')' '.mat'];
c1_residualpath = [ output_folder_mats '/' image_name_noext '_' 'c' '_channel(' channels{1} ')' '.mat'];
c2_residualpath = [ output_folder_mats '/' image_name_noext '_' 'c' '_channel(' channels{2} ')' '.mat'];
c3_residualpath = [ output_folder_mats '/' image_name_noext '_' 'c' '_channel(' channels{3} ')' '.mat'];
c1_curvpath = [ output_folder_mats '/' image_name_noext '_' 'w' '_channel(' channels{1} ')' '.mat'];
c2_curvpath = [ output_folder_mats '/' image_name_noext '_' 'w' '_channel(' channels{2} ')' '.mat'];
c3_curvpath = [ output_folder_mats '/' image_name_noext '_' 'w' '_channel(' channels{3} ')' '.mat'];


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
struct.image.oM = struct.image.M;
struct.image.oN = struct.image.N;
struct.image.fixationY = round(struct.image.oM/2);
struct.image.fixationX = round(struct.image.oN/2);
struct.image.single = experiment_name;
[struct.image.name] = experiment_name;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Calc scales and orient %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        




mkdir(output_folder_imgs);
mkdir(output_folder_mats);
mkdir(output_folder_figs);

if exist(image_struct_path, 'file') && exist(c1_iFactorpath, 'file') && exist(c2_iFactorpath, 'file') && exist(c3_iFactorpath, 'file') && exist(c1_residualpath, 'file') && exist(c2_residualpath, 'file') && exist(c3_residualpath, 'file')
	
	%do nothing, recall afterwards
	neurocalculate = 0;
	neurorecons = 1;
else
	neurocalculate = 1;
	neurorecons = 1;
end


orig_channels = size(input_image,3);

%if image is monochromatic, copy channels
if(orig_channels<3)
        input_image(:,:,2) = input_image(:,:,1);
        input_image(:,:,3) = input_image(:,:,1);
        
end
if orig_channels < 3
    start_op = 3;
    end_op = 3;
else
    start_op=1;
    end_op = 3;
end
channels={'chromatic', 'chromatic2', 'intensity'};

aux_input_image = input_image;

for k=1:nscans
    
    input_image = aux_input_image;
    
    %resize if necessary
    if ds_res ~= -1    
        input_image = autoresize(input_image,ds_res);
    else
        input_image = autoresize(input_image);
    end

    if nd_res ~= 0
        input_image = autoresize_nd(input_image,struct,nd_res);
    end
    
    %foveate function
    if fovear == 1
        input_image = foveate(input_image,0,struct);
    end
    
    %if n_scales = 0
    [struct.wave.n_scales, struct.wave.ini_scale, struct.wave.fin_scale]= calc_scales(input_image, struct.wave.ini_scale, struct.wave.fin_scale_offset, struct.wave.mida_min, struct.wave.multires); % calculate number of scales (n_scales) automatically

    [struct.wave.n_orient] = calc_norient(input_image,struct.wave.multires,struct.wave.n_scales,struct.zli.n_membr);
    devlog(strcat('Nombre scales a la funci channel_v1_0: ', num2str(struct.wave.n_scales)));
        

    if neurocalculate == 1
		disp([image_name_noext ' pre neurodynamical process ']);
		
		input_image = double(input_image);
		devlog(int2str(size(input_image(:,:,1))) );
		
		


		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%% Plot and store  struct %%%%%%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		store_matrix_givenparams(struct,'struct',struct);

		
		
		% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% %%%%%%%  stimulus (image) to opponent, + gamma correction
		% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


		input_image = get_the_cstimulus(input_image,struct.image.gamma,struct.image.srgb_flag);%! color  to opponent



        
        
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%% Apply neurodynamical %%%%%%%%%%%%%%
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
        
        
        
        
		for op=start_op:end_op
            
		    channel = channels{op};
		    im_opponent = input_image(:,:,op);

		    %im_opponent_dynamic = dynrep_channel(im_opponent,struct.zli.n_membr); %if static, replicate frames

		    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		    %%%%% wavelet decomposition %%%%%%%
		    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		     [w,c] = multires_dispatcher(im_opponent, struct.wave.multires,struct.wave.n_scales, struct.wave.n_orient);
            %[w,c] = multires_dispatcher(im_opponent, 'a_trous',struct.wave.n_scales, struct.wave.n_orient);
            %[w,c] = multires_dispatcher(im_opponent, 'wav',struct.wave.n_scales, struct.wave.n_orient);
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		    %%%%% store dwt (curv) %%%%%%%
		    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            store_matrix_givenparams_channel(w,'w',channel,struct);
            store_matrix_givenparams_channel(c,'c',channel,struct);
            
            
		        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		    %%%%% apply neurodinamic %%%%%%%
		    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		    t_ini=tic;
		    disp([image_name_noext ' neurodynamical process on channel: ' channel]);
            
            
            
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%% IN MATLAB %%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                [iFactor, iFactor_ON, iFactor_OFF] =NCZLd_channel_ON_OFF(w,struct,channel);

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%% IN C++ %%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %[iFactor_single,iFactor] = NCZLd_periter_mex(w,struct); %iFactor_single has mean of memtime and iter (scale and orientation dimensions)
                
                 
            
            toc(t_ini);

            %from {ff}{iter}{s}(:,:,o) to {ff}{iter}{s}{o}
            for ff=1:struct.zli.n_membr
                     for iter=1:struct.zli.n_iter
                         [iFactor{ff}{iter},~] = multires_decomp2curv(iFactor{ff}{iter},c,struct.wave.n_scales,struct.wave.n_orient);
                     end
            end
                 
		    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		    %%%%% store iFactor %%%%%%%
		    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
                store_matrix_givenparams_channel(iFactor,'iFactor',channel,struct);


            	%if struct.image.tmem_rw_res == 1
		    %    iFactor_meanized = timatrix_to_matrix(iFactor,struct);
		    %    store_matrix_givenparams_channel(iFactor_meanized,'iFactor',channel,struct);
		    %end
        end
        
        if orig_channels < 2 %grayscale image
                copyfile(c3_curvpath,c1_curvpath);
                copyfile(c3_curvpath,c2_curvpath);
                copyfile(c3_residualpath,c1_residualpath);
                copyfile(c3_residualpath,c2_residualpath);
                copyfile(c3_iFactorpath,c1_iFactorpath);
                copyfile(c3_iFactorpath,c2_iFactorpath);
        end
	end
    

    if neurorecons == 1

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
    c2_iFactor = load(c2_iFactorpath); c2_iFactor = c2_iFactor.matrix_in; 
    c2_residual = load(c2_residualpath); c2_residual = c2_residual.matrix_in;
    c3_iFactor = load(c3_iFactorpath); c3_iFactor = c3_iFactor.matrix_in; 
    c3_residual = load(c3_residualpath); c3_residual = c3_residual.matrix_in;
    
    c1_iFactor =  c1_iFactor(~cellfun('isempty',c1_iFactor));
    c2_iFactor =  c2_iFactor(~cellfun('isempty',c2_iFactor));
    c3_iFactor =  c3_iFactor(~cellfun('isempty',c3_iFactor));
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

%          for ff=1:image_struct.zli.n_membr
%              for it=1:image_struct.zli.n_iter
%                 c1_iFactor{ff}{it}{image_struct.wave.n_scales}{1} = zeros(size(c1_iFactor{ff}{it}{image_struct.wave.n_scales}{1}));
%                 c2_iFactor{ff}{it}{image_struct.wave.n_scales}{1} = zeros(size(c2_iFactor{ff}{it}{image_struct.wave.n_scales}{1}));
%                 c3_iFactor{ff}{it}{image_struct.wave.n_scales}{1} = zeros(size(c3_iFactor{ff}{it}{image_struct.wave.n_scales}{1}));
%              end
%          end
        

    end
    
	    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%unified RF cells %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        RF_ti_s_o_c = unify_channels_ti(c1_iFactor,c2_iFactor,c3_iFactor,image_struct);
        
        residual_s_c = unify_channels_norient(c1_residual,c2_residual,c3_residual,image_struct);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%recons function %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        RF_s_o_c = timatrix_to_matrix(RF_ti_s_o_c,struct);
        
        
        
        %compute eCSF
        if strcmp(struct.compute.output_from_csf,'eCSF') == 1
            [RF_s_o_c] = apply_eCSF_percanal(RF_s_o_c, struct);
        end

        %inverse decomposition or max then inverse decomposition
        switch (struct.compute.smethod)
            case 'pmax2'
                [RF_s,residual_s] = get_RF_max_t(RF_s_o_c,residual_s_c,struct);        
                RF_s_o = repicate_orient(RF_s,struct);

                %despues de maximos solo hay un canal que copiar y reconstruir, que son los maximos
                [RF_s_o,residual_s] = multires_curv2decomp(RF_s_o,residual_s,struct.wave.n_scales,struct.wave.n_orient);
                RF_c(:,:,1) = multires_inv_dispatcher(RF_s_o,residual_s,struct.wave.multires,struct.wave.n_scales,struct.wave.n_orient);
                RF_c(:,:,2) = RF_c(:,:,1);
                RF_c(:,:,3) = RF_c(:,:,1);

            case 'pmaxc'
                [RF_s_o,residual_s] = get_RF_max_t_o(RF_s_o_c,residual_s_c,struct);   

                %despues de maximos solo hay un canal, que son los maximos
                [RF_s_o,residual_s] = mutires_curv2decomp(RF_s_o,residual_s,struct.wave.n_scales,struct.wave.n_orient);
                RF_c(:,:,1) = multires_inv_dispatcher(RF_s_o,residual_s,struct.wave.multires,struct.wave.n_scales,struct.wave.n_orient);
                RF_c(:,:,2) = RF_c(:,:,1);
                RF_c(:,:,3) = RF_c(:,:,1);
            otherwise

                
                
                [c1_RF_s_o,c2_RF_s_o,c3_RF_s_o] = separate_channels(RF_s_o_c,struct);
                [c1_residual_s,c2_residual_s,c3_residual_s] = separate_channels_norient(residual_s_c,struct);
                
                [c1_RF_s_o,c1_residual_s] = mutires_curv2decomp(c1_RF_s_o,c1_residual_s,struct.wave.n_scales,struct.wave.n_orient);
                [c2_RF_s_o,c2_residual_s] = mutires_curv2decomp(c2_RF_s_o,c2_residual_s,struct.wave.n_scales,struct.wave.n_orient);
                [c3_RF_s_o,c3_residual_s] = mutires_curv2decomp(c3_RF_s_o,c3_residual_s,struct.wave.n_scales,struct.wave.n_orient);
                RF_c(:,:,1) = multires_inv_dispatcher(c1_RF_s_o,c1_residual_s,struct.wave.multires,struct.wave.n_scales,struct.wave.n_orient);
                RF_c(:,:,2) = multires_inv_dispatcher(c2_RF_s_o,c2_residual_s,struct.wave.multires,struct.wave.n_scales,struct.wave.n_orient);
                RF_c(:,:,3) = multires_inv_dispatcher(c3_RF_s_o,c3_residual_s,struct.wave.multires,struct.wave.n_scales,struct.wave.n_orient);

        end


        %from opponent to color (no)
        if struct.compute.orgb_flag == 1  
            RF_c = get_the_ostimulus(RF_c,struct.image.gamma,struct.image.srgb_flag);
        end 


        %combine channels
        switch (struct.compute.smethod)
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



        %normalize according to a specific type (Z, energy ...)
        switch(struct.compute.fusion)
            case 1	

                  smap = normalize_energy(smap);

            case 2

                  smap = normalize_Z(smap);
            case 3

                smap = normalize_minmax(smap);
            case 4
                smap = normalize_energy(smap);
                smap = normalize_minmax(smap);

            case 5
                smap = normalize_Z(smap);
                smap = normalize_minmax(smap);
            case 6
                smap = normalize_Zp(smap);
                smap = normalize_minmax(smap);

            otherwise
                %do nothing
        end
    
        %undistort
        if struct.image.foveate == 1
            smap = foveate(smap,1,struct);
        end

        %space to uint8
        smap = smap*255;
        smap = uint8(smap);
    end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%calculate scanpath and refixate %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [maxval, maxidx] = max(smap(:));
        [scanpath(k,1), scanpath(k,2)] = ind2sub(size(smap),maxidx); %x,y
        
        struct.image.fixationY = scanpath(k,2);
        struct.image.fixationX = scanpath(k,1);
        
        imwrite(smap, [ output_folder_imgs '/' num2str(k) '_' scanpath_prefix_img output_image output_extension]);
        
        scanpath_mean(:,:,k) = smap;
end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%write image %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %make mean of all smaps per N fixations
    final_smap = normalize_minmax(mean(scanpath_mean,3));
    imwrite(final_smap,[output_image_path]);
    
    save(output_scanpath_path,'scanpath');
    
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


