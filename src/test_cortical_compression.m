function [ score_sims,score_psnr ] = test_cortical_compression( image_path )
    if nargin<1, image_path='input/111.png'; end
    img=double(imread(image_path))./255;
    [imgfolder,imgname,imgext]=fileparts(image_path);
    
        struct.cortex_params.cm_method = 'schwartz_monopole';
        struct.cortex_params.a=1;
    %         struct.cortex_params.a=degtorad(0.77);
    %         struct.cortex_params.a=0.0134;
    %         struct.cortex_params.b=degtorad(150);
        struct.cortex_params.b=2.6180;
        struct.cortex_params.alpha1=0.95;
        struct.cortex_params.alpha2=0.5;
        struct.cortex_params.alpha3=0.2;
        struct.cortex_params.lambda=12;
        struct.cortex_params.isoPolarGrad=0.1821;
        struct.cortex_params.eccWidth=0.7609;
        struct.cortex_params.cortex_max_elong_mm = 120;
        struct.cortex_params.cortex_max_az_mm = 60;
        struct.cortex_params.mirroring = 1;

        struct.gaze_params.orig_width = size(img,2); %unknown on undistort
        struct.gaze_params.orig_height = size(img,1); %unknown on undistort
        struct.gaze_params.img_diag_angle = degtorad(35.12);
        struct.gaze_params.fov_type = 'cortical';

        struct.gaze_params.fov_x = round(struct.gaze_params.orig_width/2);
        struct.gaze_params.fov_y = round(struct.gaze_params.orig_height/2);
        
    mkdir(['figs' '/' 'cortical' '/']);
    cortex_widths=[64,128,256,512,1024,2048,4096];
    for w=1:length(cortex_widths)
        struct.cortex_params.cortex_width = cortex_widths(w);
        [img_cortex,img_reconstructed]=plot_cm(image_path,struct);
        imwrite(img_reconstructed,['figs' '/' 'cortical' '/' 'recons_' 'width_' num2str(cortex_widths(w)) '_'  imgname '.png']);
        imwrite(img_cortex,['figs' '/' 'cortical' '/' 'cortex_' 'width_' num2str(cortex_widths(w)) '_'  imgname '.png']);
%         score_sims(w)=ssim(img,img_reconstructed);
%         score_psnr(w)=psnr(img,img_reconstructed);
    end
    
    plot(cortex_widths,score_sims,'-o');
    ylabel('Similarity');
    xticks(cortex_widths);
    xticklabels(cortex_widths);
    xlabel('Cortex Width');
    xtickangle(45);
    set(gca,'FontSize',5);
    saveas(gcf,['figs' '/' 'cortical' '/' 'similarities_' imgname '.png']);
    close all;
    
    plot(cortex_widths,score_psnr,'-o');
    ylabel('PSNR');
    xticks(cortex_widths);
    xticklabels(cortex_widths);
    xlabel('Cortex Width');
    xtickangle(45);
    set(gca,'FontSize',5);
    saveas(gcf,['figs' '/' 'cortical' '/' 'psnr_' imgname '.png']);
    close all;
%     
end

