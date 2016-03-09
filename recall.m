


%reads eCSF and iFactor from outputted .mats and computes the IDWT, mean in time, normalization ... 
function [] = recall(image_name, conf_struct_path)
    
    if nargin < 2
	conf_struct_path = 'default_struct.mat';
    conf_struct = load(conf_struct_path);
    else
        [conf_struct_path_folder,conf_struct_path_name,conf_struct_path_ext] = fileparts(conf_struct_path);
        conf_struct = load(conf_struct_path);
    end
    conf_struct = conf_struct.matrix_in;
    
    
    
    output_folder = 'output';
    output_subfolder = conf_struct_path_name ;
    output_path = [output_folder '/' output_subfolder '/'];
    output_folder_imgs = output_path; %output_folder_imgs = [output_path 'output_imgs'];
    output_folder_mats = 'mats'; %output_folder_mats = [output_path 'output_mats'];
    output_extension = '.png';
    image_name_noext = remove_extension(image_name);
    output_image = [image_name_noext output_extension];
    
    image_struct_path = [ output_folder_mats '/' image_name_noext '_' 'struct' '.mat'];
    image_struct = load(image_struct_path); image_struct = image_struct.matrix_in;
    image_struct.compute = conf_struct.compute;
    image_struct.image = conf_struct.image;
    
    channels = {'chromatic', 'chromatic2' ,'intensity'};
    
    
    c1_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{1} ')' '.mat'];
    c1_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{1} ')' '.mat'];
    c1_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{1} ')' '.mat'];
    
    c2_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{2} ')' '.mat'];
    c2_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{2} ')' '.mat'];
    c2_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{2} ')' '.mat'];
    
    c3_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{3} ')' '.mat'];
    c3_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{3} ')' '.mat'];
    c3_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{3} ')' '.mat'];
    
    
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
    
    
    
    %residual forced to zero
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
   
    
    
    %saved mats are saved per tmem (ex. from 1 to 10) or already meanized?
    if image_struct.image.tmem_rw_res == 0
	    
        
        RF_t_s_o_c = unify_channels_t(c1_iFactor,c2_iFactor,c3_iFactor,image_struct);
        
        residual_s_c = unify_channels_norient(c1_residual,c2_residual,c3_residual,image_struct);
        
        Ls_s_c = unify_channels_norient(c1_Ls,c2_Ls,c3_Ls,image_struct);
    
		smap = RF_to_smap(RF_t_s_o_c,residual_s_c,Ls_s_c,image_struct);

    
    else

        RF_s_o_c = unify_channels(c1_iFactor,c2_iFactor,c3_iFactor,image_struct);
        
        residual_s_c = unify_channels_norient(c1_residual,c2_residual,c3_residual,image_struct);
        
        
        Ls_s_c = unify_channels_norient(c1_Ls,c2_Ls,c3_Ls,image_struct);
        
    
		smap = RF_to_smap_t(RF_s_o_c,residual_s_c,Ls_s_c,image_struct);

		

    end
    
    
    %write image
    imwrite(smap,[output_folder_imgs '/'  output_image]);
    
    
    
    
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


