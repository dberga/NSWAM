function [ X,Y ] = get_ij2XY( i,j,cortex_params,gaze_params)

 cortex_params.cortex_height = round((cortex_params.cortex_max_az_mm/cortex_params.cortex_max_elong_mm)*cortex_params.cortex_width);

%%%%%%debug
%     proportion=cortex_params.cortex_width/gaze_params.orig_width;
%     width_gaussian=rad2deg(gaze_params.img_diag_angle);
%     width_gaussian_cortex=width_gaussian*proportion;
%     figure,imagesc(zhong2012(scanpath2bmap([i j],[gaze_params.orig_height gaze_params.orig_width]),width_gaussian));
    
    
    %get idx from image
    idx=sub2ind([gaze_params.orig_height gaze_params.orig_width],i,j);
    
    cortex_params.mirroring=0;
    
   
    cortex = zeros(cortex_params.cortex_height,cortex_params.cortex_width);

    cortex_width_2 = cortex_params.cortex_width/2; 
    cortex_height_2 = cortex_params.cortex_height/2;
    cortex_width_2 = cortex_params.cortex_width/2;
    cortex_height_2 = cortex_params.cortex_height/2;

    img = zeros(gaze_params.orig_height,gaze_params.orig_width);

    cortex_elong2pix_mm = cortex_params.cortex_width/cortex_params.cortex_max_elong_mm;
    cortex_az2pix_mm = cortex_params.cortex_height/cortex_params.cortex_max_az_mm;

    img_diag_pix = sqrt(gaze_params.orig_width*gaze_params.orig_width+gaze_params.orig_height*gaze_params.orig_height);

    img_elong_angle = gaze_params.img_diag_angle*gaze_params.orig_width/img_diag_pix;
    img_az_angle = gaze_params.img_diag_angle*gaze_params.orig_height/img_diag_pix;

    eye_pix2elong = img_elong_angle/gaze_params.orig_width;
    eye_pix2az = img_az_angle/gaze_params.orig_height;

    [img_rows, img_cols] = ind2sub(size(img),[1:numel(img)]);
    coord_img = [1:numel(img)];

    image_azimuth=(img_rows-gaze_params.fov_y)*eye_pix2az;
    image_eccentricity=(img_cols-gaze_params.fov_x)*eye_pix2elong;


    % cX=reshape(image_eccentricity,[512 682]); 
    % cX(:,1:682/2)=-fliplr(cX(:,682/2+1:end));
    % image_eccentricity=reshape(cX,[1 512*682]);
    % 
    % cY=reshape(image_azimuth,[512 682]); 
    % cY(1:512/2,:)=-flipud(cY(512/2+1:end,:));
    % image_azimuth=reshape(cY,[1 512*682]);

    switch cortex_params.cm_method
        case 'schwartz_monopole'
            [coord_X_cortex,coord_Y_cortex] = schwartz_monopole(image_azimuth, image_eccentricity,cortex_params.lambda,cortex_params.a);
        case 'schwartz_dipole'
            [coord_X_cortex,coord_Y_cortex] = schwartz_dipole(image_azimuth, image_eccentricity,cortex_params.lambda,cortex_params.a,cortex_params.b);
        %case 'dsech_monopole'
        %    [coord_X_cortex,coord_Y_cortex] = dsech_monopole(image_azimuth, image_eccentricity,cortex_params.lambda,cortex_params.a,cortex_params.eccWidth,cortex_params.isoPolarGrad);
        %case 'dsech_dipole'
        %    [coord_X_cortex,coord_Y_cortex] = dsech_dipole(image_azimuth, image_eccentricity,cortex_params.lambda,cortex_params.a,cortex_params.b,cortex_params.eccWidth,cortex_params.isoPolarGrad);
        case 'wedge_monopole'
            [coord_X_cortex,coord_Y_cortex] = wedge_monopole(image_azimuth, image_eccentricity,cortex_params.lambda,cortex_params.a,cortex_params.alpha1,cortex_params.alpha2,cortex_params.alpha3);
        otherwise
            [coord_X_cortex,coord_Y_cortex] = schwartz_monopole(image_azimuth, image_eccentricity,cortex_params.lambda,cortex_params.a);
    end

    % cX=reshape(coord_X_cortex,[512 682]); 
    % cX(:,1:682/2)=-fliplr(cX(:,682/2+1:end));
    % coord_X_cortex=reshape(cX,[1 512*682]);

    %el problema esta aqui, imagesc(reshape(coord_X_cortex,[512 682]))
    cortex_cols = (coord_X_cortex*cortex_elong2pix_mm)+cortex_width_2;
    cortex_rows = (coord_Y_cortex*cortex_az2pix_mm)+cortex_height_2; 

    coord_cortex = [cortex_rows;cortex_cols];

    X=cortex_cols(idx);
    Y=cortex_rows(idx);
%%%%%%debug
%     figure,imagesc(zhong2012(scanpath2bmap(round([Y X]),[cortex_params.cortex_height cortex_params.cortex_width]),width_gaussian_cortex));
    
    
end

