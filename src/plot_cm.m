function [  ] = plot_cm( input_image_path )
    if nargin<1, input_image_path='input/111.png'; end
    img=double(imread(input_image_path))./255;
    
    
        struct.cortex_params.cm_method = 'schwartz_monopole';
        struct.cortex_params.cortex_width = 1024;
%         cortex_params.a=degtorad(0.77);
        struct.cortex_params.a=0.0134;
%         cortex_params.b=degtorad(150);
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
        
    imgout=foveate(img, 0 , struct);
    
    imagesc(imgout);
end

