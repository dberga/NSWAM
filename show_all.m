function [  ] = show_all( image_name )

    image_name_noext = remove_extension(image_name);

    input_folder = 'input';
    output_folder_mats = 'mats';
    figs_folder = 'figs';
    
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
    

    c1_iFactor = load(c1_iFactorpath); c1_iFactor = c1_iFactor.matrix_in; 
    c2_iFactor = load(c2_iFactorpath); c2_iFactor = c2_iFactor.matrix_in; 
    c3_iFactor = load(c3_iFactorpath); c3_iFactor = c3_iFactor.matrix_in; 
    c1_iFactor = cleanRF(c1_iFactor);
    c2_iFactor = cleanRF(c2_iFactor);
    c3_iFactor = cleanRF(c3_iFactor);
    c1_curv = load(c1_curvpath); c1_curv = c1_curv.matrix_in; 
    c2_curv = load(c2_curvpath); c2_curv = c2_curv.matrix_in; 
    c3_curv = load(c3_curvpath); c3_curv = c3_curv.matrix_in; 
    c1_curv = cleanWAV(c1_curv);
    c2_curv = cleanWAV(c2_curv);
    c3_curv = cleanWAV(c3_curv);
    c1_residual = load(c1_residualpath); c1_residual = c1_residual.matrix_in; 
    c2_residual = load(c2_residualpath); c2_residual = c2_residual.matrix_in; 
    c3_residual = load(c3_residualpath); c3_residual = c3_residual.matrix_in; 
    c1_residual = cleanWAV(c1_residual);
    c2_residual = cleanWAV(c2_residual);
    c3_residual = cleanWAV(c3_residual);
    
    image = imread([input_folder '/' image_name]);
    image_struct = load(image_struct_path); image_struct = image_struct.matrix_in;
    
    
    
    %WAVE CHROMATIC 1
    figure; [fig] = show_wav(c1_curv,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'curv_'  channels{1} '.png']);
    close all;
    
    %WAVE CHROMATIC 2
    figure; [fig] = show_wav(c2_curv,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'curv_'  channels{2} '.png']);
    close all;
    
    %WAVE CHROMATIC 3
    figure; [fig] = show_wav(c3_curv,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'curv_'  channels{3} '.png']);
    close all;
    
    %IFACTOR CHROMATIC 1
    [figs] = show_RF_dynamic(c1_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    for f=1:numel(figs)
        fig = figs(f);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_'  channels{1} '_' int2str(f) '.png']);
    end
    close all;
    
    %IFACTOR CHROMATIC 2
    [figs] = show_RF_dynamic(c2_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    for f=1:numel(figs)
        fig = figs(f);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_'  channels{2} '_' int2str(f) '.png']);
    end
    close all;
    
    %IFACTOR CHROMATIC 3
    [figs] = show_RF_dynamic(c3_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    for f=1:numel(figs)
        fig = figs(f);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_' channels{3} '_' int2str(f) '.png']);
    end
    close all;
    
    %IFACTOR ACTIVITY CHROMATIC 1
    [activity,activity_mean] = show_activity(c1_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    [fig] = show_activity_plots(activity);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_' channels{1} '.png']);
    close all;
    figure; fig = plot(activity_mean);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_mean_' channels{1} '.png']);
    close all;
    
    %IFACTOR ACTIVITY CHROMATIC 2
    [activity,activity_mean] = show_activity(c1_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    [fig] = show_activity_plots(activity);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_' channels{2} '.png']);
    close all;
    figure; fig = plot(activity_mean);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_mean_' channels{2} '.png']);
    close all;
    
    %IFACTOR ACTIVITY CHROMATIC 3
    [activity,activity_mean] = show_activity(c3_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    [fig] = show_activity_plots(activity);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_' channels{3} '.png']);
    close all;
    figure; fig = plot(activity_mean);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_mean_' channels{3} '.png']);
    close all;
    
end

