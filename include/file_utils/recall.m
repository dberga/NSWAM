
%reads eCSF and iFactor from outputted .mats and computes the IDWT, mean in time, normalization ... 
function [] = recall(image_name)
    
    
    
    
    output_folder = 'output';
    output_folder_mats = [output_folder '/' 'output_mats'];
    output_folder_imgs = [output_folder '/' 'output_imgs'];
    output_extension = '.png';
    image_name_noext = remove_extension(image_name);
    output_image = ['s' image_name_noext output_extension];
    
    struct_path = [ output_folder_mats '/' image_name '_' 'struct' '.mat'];
    struct = load(struct_path); struct = struct.matrix_in;
    channels = {'chromatic', 'chromatic2' ,'intensity'};
    
    c1_eCSFpath = [ output_folder_mats '/' image_name '_' 'eCSF' '_channel(' channels{1} ')' '.mat'];
    c1_residualpath = [ output_folder_mats '/' image_name '_' 'residual' '_channel(' channels{1} ')' '.mat'];
    c1_Lspath = [ output_folder_mats '/' image_name '_' 'Ls' '_channel(' channels{1} ')' '.mat'];
    c1_iFactorpath = [ output_folder_mats '/' image_name '_' 'iFactor' '_channel(' channels{1} ')' '.mat'];
    
    c2_eCSFpath = [ output_folder_mats '/' image_name '_' 'eCSF' '_channel(' channels{2} ')' '.mat'];
    c2_residualpath = [ output_folder_mats '/' image_name '_' 'residual' '_channel(' channels{2} ')' '.mat'];
    c2_Lspath = [ output_folder_mats '/' image_name '_' 'Ls' '_channel(' channels{2} ')' '.mat'];
    c2_iFactorpath = [ output_folder_mats '/' image_name '_' 'iFactor' '_channel(' channels{2} ')' '.mat'];
    
    c3_eCSFpath = [ output_folder_mats '/' image_name '_' 'eCSF' '_channel(' channels{3} ')' '.mat'];
    c3_residualpath = [ output_folder_mats '/' image_name '_' 'residual' '_channel(' channels{3} ')' '.mat'];
    c3_Lspath = [ output_folder_mats '/' image_name '_' 'Ls' '_channel(' channels{3} ')' '.mat'];
    c3_iFactorpath = [ output_folder_mats '/' image_name '_' 'iFactor' '_channel(' channels{3} ')' '.mat'];
    
    c1_residual = load(c1_residualpath); c1_residual = c1_residual.matrix_in;
    c1_Ls = load(c1_Lspath); c1_Ls = c1_Ls.matrix_in;
    c2_residual = load(c2_residualpath); c2_residual = c2_residual.matrix_in;
    c2_Ls = load(c2_Lspath); c2_Ls = c2_Ls.matrix_in;
    c3_residual = load(c3_residualpath); c3_residual = c3_residual.matrix_in;
    c3_Ls = load(c3_Lspath); c3_Ls = c3_Ls.matrix_in;

    c1_eCSF = load(c1_eCSFpath); c1_eCSF = c1_eCSF.matrix_in;
    c2_eCSF = load(c2_eCSFpath); c2_eCSF = c2_eCSF.matrix_in;
    c3_eCSF = load(c3_eCSFpath); c3_eCSF = c3_eCSF.matrix_in;
    
    
     for ff=1:struct.zli.n_membr
        c1_eCSF{ff}{struct.wave.n_scales}{1} = 0;
        c2_eCSF{ff}{struct.wave.n_scales}{1} = 0;
        c3_eCSF{ff}{struct.wave.n_scales}{1} = 0;
     end
     
     
    c1_iFactor = load(c1_iFactorpath); c1_iFactor = c1_iFactor.matrix_in;
    c2_iFactor = load(c2_iFactorpath); c2_iFactor = c2_iFactor.matrix_in;
    c3_iFactor = load(c3_iFactorpath); c3_iFactor = c3_iFactor.matrix_in;
   
    for ff=1:struct.zli.n_membr
        c1_iFactor{ff}{struct.wave.n_scales}{1} = 0;
        c2_iFactor{ff}{struct.wave.n_scales}{1} = 0;
        c3_iFactor{ff}{struct.wave.n_scales}{1} = 0;
     end
    
    c1_iFactor_rec = RF_to_rec_channel(c1_iFactor,c1_residual,c1_Ls,struct);
    c2_iFactor_rec = RF_to_rec_channel(c2_iFactor,c2_residual,c2_Ls,struct);
    c3_iFactor_rec = RF_to_rec_channel(c3_iFactor,c3_residual,c3_Ls,struct);
    iFactor_rec(:,:,1,:) = c1_iFactor_rec;
    iFactor_rec(:,:,2,:) = c2_iFactor_rec;
    iFactor_rec(:,:,3,:) = c3_iFactor_rec;
    iFactor_recmean = static_computeframesmean(iFactor_rec,struct.zli.n_membr,struct.zli.n_frames_promig);
    iFactor_rec_rgb = get_the_ostimulus(iFactor_recmean,struct.image.gamma,struct.image.srgb_flag);
    
    smap_iFactor = rec_to_smap(iFactor_rec_rgb);
    imwrite(smap_iFactor,[output_folder_imgs '/' 'iFactor_' output_image]);
    
    
    c1_eCSF_rec = RF_to_rec_channel(c1_eCSF,c1_residual,c1_Ls,struct);
    c2_eCSF_rec = RF_to_rec_channel(c2_eCSF,c2_residual,c2_Ls,struct);
    c3_eCSF_rec = RF_to_rec_channel(c3_eCSF,c3_residual,c3_Ls,struct);
    eCSF_rec(:,:,1,:) = c1_eCSF_rec;
    eCSF_rec(:,:,2,:) = c2_eCSF_rec;
    eCSF_rec(:,:,3,:) = c3_eCSF_rec;
    eCSF_recmean = static_computeframesmean(eCSF_rec,struct.zli.n_membr,struct.zli.n_frames_promig);
     eCSF_rec_rgb = get_the_ostimulus(eCSF_recmean,struct.image.gamma,struct.image.srgb_flag);
     
    smap_eCSF = rec_to_smap(eCSF_rec_rgb);
    imwrite(smap_eCSF,[output_folder_imgs '/' 'eCSF_' output_image]);
   
    
end

