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
    
    %OPPONENTS
    image_opponents = get_the_cstimulus(image,image_struct.image.gamma,image_struct.image.srgb_flag);%! color  to opponent
    mosaic = zeros(size(image_opponents,1),size(image_opponents,2),1,size(image_opponents,3)); mosaic(:,:,1,:) = image_opponents(:,:,:);
    figure; [fig] = montage(mosaic, 'Size',[1 3]);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'opponents_' image_name_noext '.png']);
    
    
    
    %FOVEATED RGB IMAGE(illustration)
        %gaze on middle
        image_struct.image.cortex_width = 512;
        image_struct.image.e0 = 1;
        image_struct.image.vAngle = 180;
        image_struct.image.fixationX = round(size(image,2)/2);
        image_struct.image.fixationY = round(size(image,1)/2);
        image_foveated = foveate(image,0,image_struct);
        figure; [fig] = imshow(image_foveated/255);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[figs_folder '/' 'magnified_rgb_gaze1_' image_name_noext '.png']);

        %gaze on first corner
        image_struct.image.cortex_width = 512;
        image_struct.image.e0 = 1;
        image_struct.image.vAngle = 180;
        image_struct.image.fixationX = round(size(image,2)/3);
        image_struct.image.fixationY = round(size(image,1)/3);
        image_foveated = foveate(image,0,image_struct);
        figure; [fig] = imshow(image_foveated/255);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[figs_folder '/' 'magnified_rgb_gaze2_' image_name_noext '.png']);

        %gaze on pepper1
        image_struct.image.cortex_width = 512;
        image_struct.image.e0 = 1;
        image_struct.image.vAngle = 180;
        image_struct.image.fixationX = 460; %469
        image_struct.image.fixationY = 196; %190
        image_foveated = foveate(image,0,image_struct);
        figure; [fig] = imshow(image_foveated/255);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[figs_folder '/' 'magnified_rgb_gaze3_' image_name_noext '.png']);

        %gaze on pepper2
        image_struct.image.cortex_width = 512;
        image_struct.image.e0 = 1;
        image_struct.image.vAngle = 180;
        image_struct.image.fixationX = 194;
        image_struct.image.fixationY = 288;
        image_foveated = foveate(image,0,image_struct);
        figure; [fig] = imshow(image_foveated/255);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[figs_folder '/' 'magnified_rgb_gaze4_' image_name_noext '.png']);

        
    
    %FOVEATED OPPONENT CHANNELS
    image_struct.image.cortex_width = 512;
    image_struct.image.e0 = 1;
    image_struct.image.vAngle = 35.12;
    image_struct.image.fixationX = 0;
    image_struct.image.fixationY = 0;
    image_foveated = foveate(image_opponents,0,image_struct);
    mosaic = zeros(size(image_foveated,1),size(image_foveated,2),1,size(image_foveated,3)); mosaic(:,:,1,:) = image_foveated(:,:,:);
    figure; [fig] = montage(mosaic, 'Size',[1 3]);
    fig_image = getimage(fig);
    imwrite(im2uint8(fig_image),[figs_folder '/' 'magnified_opponents_' image_name_noext '.png']);
    close all;
    
        
    
    
    %WAVE CHROMATIC 1
    figure; [fig] = show_wav(c1_curv,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    fig_image = getimage(fig);
    imwrite(im2uint8(mat2gray(fig_image)),[figs_folder '/' 'curv_' channels{1} '_' image_name_noext '.png']);
    close all;
    figure; [fig] = show_wav(c1_residual,1,image_struct.wave.n_scales-1,1,1);
    fig_image = getimage(fig);
    imwrite(im2uint8(mat2gray(fig_image)),[figs_folder '/' 'residual_' channels{1} '_' image_name_noext '.png']);
    close all;
    
    %WAVE CHROMATIC 2
    figure; [fig] = show_wav(c2_curv,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    fig_image = getimage(fig);
    imwrite(im2uint8(mat2gray(fig_image)),[figs_folder '/' 'curv_'  channels{2} '_' image_name_noext '.png']);
    close all;
    figure; [fig] = show_wav(c2_residual,1,image_struct.wave.n_scales-1,1,1);
    fig_image = getimage(fig);
    imwrite(im2uint8(mat2gray(fig_image)),[figs_folder '/' 'residual_' channels{2} '_' image_name_noext '.png']);
    close all;
    
    %WAVE CHROMATIC 3
    figure; [fig] = show_wav(c3_curv,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    fig_image = getimage(fig);
    imwrite(im2uint8(mat2gray(fig_image)),[figs_folder '/' 'curv_'  channels{3} '_' image_name_noext '.png']);
    close all;
    figure; [fig] = show_wav(c3_residual,1,image_struct.wave.n_scales-1,1,1);
    fig_image = getimage(fig);
    imwrite(im2uint8(mat2gray(fig_image)),[figs_folder '/' 'residual_' channels{3} '_' image_name_noext '.png']);
    close all;
    
    %IFACTOR CHROMATIC 1
    [figs] = show_RF_dynamic(c1_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    for f=1:numel(figs)
        fig = figs(f);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_'  channels{1} '_' int2str(f) '_' image_name_noext '.png']);
    end
    close all;
    
    %IFACTOR CHROMATIC 2
    [figs] = show_RF_dynamic(c2_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    for f=1:numel(figs)
        fig = figs(f);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_'  channels{2} '_' int2str(f) '_' image_name_noext '.png']);
    end
    close all;
    
    %IFACTOR CHROMATIC 3
    [figs] = show_RF_dynamic(c3_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
    for f=1:numel(figs)
        fig = figs(f);
        fig_image = getimage(fig);
        imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_' channels{3} '_' int2str(f) '_' image_name_noext '.png']);
    end
    close all;
    
    %IFACTOR ACTIVITY CHROMATIC 1
%     [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum] = show_activity(c1_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
%     [fig] = show_activity_plots(activity_mean);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_mean_' channels{1} '_' image_name_noext '.png']);
%     close all;
%     figure; [fig] = plot(activity_mean_mean);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_mean_mean_' channels{1} '_' image_name_noext '.png']);
%     close all;
%     [fig] = show_activity_plots(activity_max);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_max_' channels{1} '_' image_name_noext '.png']);
%     close all;
%     figure; [fig] = plot(activity_max_max);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_max_max_' channels{1} '_' image_name_noext '.png']);
%     close all;
%     [fig] = show_activity_plots(activity_sum);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_sum_' channels{1} '_' image_name_noext '.png']);
%     close all;
%     figure; [fig] = plot(activity_sum_sum);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_sum_sum_' channels{1} '_' image_name_noext '.png']);
%     close all;
    
    %IFACTOR ACTIVITY CHROMATIC 2
%     [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum] = show_activity(c2_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
%     [fig] = show_activity_plots(activity_mean);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_mean_' channels{2} '_' image_name_noext '.png']);
%     close all;
%     figure; [fig] = plot(activity_mean_mean);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_mean_mean_' channels{2} '_' image_name_noext '.png']);
%     close all;
%     [fig] = show_activity_plots(activity_max);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_max_' channels{2} '_' image_name_noext '.png']);
%     close all;
%     figure; [fig] = plot(activity_max_max);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_max_max_' channels{2} '_' image_name_noext '.png']);
%     close all;
%     [fig] = show_activity_plots(activity_sum);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_sum_' channels{2} '_' image_name_noext '.png']);
%     close all;
%     figure; [fig] = plot(activity_sum_sum);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_sum_sum_' channels{2} '_' image_name_noext '.png']);
%     close all;
    
    %IFACTOR ACTIVITY CHROMATIC 3
%     [activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum] = show_activity(c3_iFactor,1,image_struct.zli.n_membr,1,image_struct.zli.n_iter,1,image_struct.wave.n_scales-1,1,image_struct.wave.n_orient);
%     [fig] = show_activity_plots(activity_mean);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_mean_' channels{3} '_' image_name_noext '.png']);
%     close all;
%     figure; [fig] = plot(activity_mean_mean);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_mean_mean_' channels{3} '_' image_name_noext '.png']);
%     close all;
%     [fig] = show_activity_plots(activity_max);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_max_' channels{3} '_' image_name_noext '.png']);
%     close all;
%     figure; [fig] = plot(activity_max_max);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_max_max_' channels{3} '_' image_name_noext '.png']);
%     close all;
%     [fig] = show_activity_plots(activity_sum);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_sum_' channels{3} '_' image_name_noext '.png']);
%     close all;
%     figure; [fig] = plot(activity_sum_sum);
%     fig_image = getimage(fig);
%     imwrite(im2uint8(fig_image),[figs_folder '/' 'iFactor_sum_sum_' channels{3} '_' image_name_noext '.png']);
%     close all;
    
end

