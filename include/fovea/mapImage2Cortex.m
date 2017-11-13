function [cortex] = mapImage2Cortex(img,cortex_params,gaze_params)


cortex_params.cortex_height = round((cortex_params.cortex_max_az_mm/cortex_params.cortex_max_elong_mm)*cortex_params.cortex_width);

cortex = zeros(cortex_params.cortex_height,cortex_params.cortex_width);

cortex_width_2 = cortex_params.cortex_width/2; 
cortex_height_2 = cortex_params.cortex_height/2;

cortex_pix2elong_mm = cortex_params.cortex_max_elong_mm/cortex_params.cortex_width;
cortex_pix2az_mm = cortex_params.cortex_max_az_mm/cortex_params.cortex_height;
% cortex_max_elong = pi/2;
% cortex_max_az = pi;
% cortex_pix2elong = cortex_max_elong/cortex_width;
% cortex_pix2az = cortex_max_az/cortex_height;


img_diag_pix = sqrt(gaze_params.orig_width*gaze_params.orig_width+gaze_params.orig_height*gaze_params.orig_height);

img_elong_angle = gaze_params.img_diag_angle*gaze_params.orig_width/img_diag_pix;
img_az_angle = gaze_params.img_diag_angle*gaze_params.orig_height/img_diag_pix;

eye_elong2pix = gaze_params.orig_width/img_elong_angle;
eye_az2pix = gaze_params.orig_height/img_az_angle;


%[cortex_rows, cortex_cols] = custom_ind2sub(size(cortex),[1:numel(cortex)]);
[cortex_rows, cortex_cols] = ind2sub(size(cortex),[1:numel(cortex)]);
coord_cortex = [1:numel(cortex)]; %sub2ind(size(cortex),cortex_rows, cortex_cols);

coord_Y_cortex = (cortex_rows-cortex_height_2)*cortex_pix2az_mm;
coord_X_cortex = (cortex_cols-cortex_width_2)*cortex_pix2elong_mm;


% cX=reshape(coord_X_cortex,size(cortex));
% cX(cX>=0)=-flipud(cX(cX<0));
% cY=reshape(coord_Y_cortex,size(cortex));
% cY(cY>=0)=-flipud(cY(cY<0));
% coord_X_cortex=reshape(cX,[1 size(cortex,1)*size(cortex,2)]);
% coord_Y_cortex=reshape(cY,[1 size(cortex,1)*size(cortex,2)]);

switch cortex_params.cm_method
    case 'schwartz_monopole'
        [image_azimuth, image_eccentricity] = schwartz_monopole_inv(coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a);
    case 'schwartz_dipole'
        [image_azimuth, image_eccentricity] = schwartz_dipole_inv(  coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a,cortex_params.b);
    %case 'dsech_monopole'
    %    [image_azimuth, image_eccentricity] = dsech_monopole_inv( coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a,cortex_params.eccWidth,cortex_params.isoPolarGrad);
    %case 'dsech_dipole'
    %    [image_azimuth, image_eccentricity] = dsech_dipole_inv( coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a,cortex_params.b,cortex_params.eccWidth,cortex_params.isoPolarGrad);
    case 'wedge_monopole'
        [image_azimuth, image_eccentricity] = wedge_monopole_inv(  coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a,cortex_params.alpha1,cortex_params.alpha2,cortex_params.alpha3);
    otherwise
        [image_azimuth, image_eccentricity] = schwartz_monopole_inv(  coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a);
end

%el problema esta aqui,  imagesc(reshape(image_azimuth,[64 128]))
img_cols = image_eccentricity*eye_elong2pix+gaze_params.fov_x;
img_rows = image_azimuth*eye_az2pix+gaze_params.fov_y;
coord_img = [img_rows;img_cols];
%coord_img = round(coord_img);

coord_img_min_limit = repmat([1 1],[numel(cortex) 1]);
coord_img_max_limit = repmat([gaze_params.orig_height gaze_params.orig_width],[numel(cortex) 1]);

inside_img = inside(coord_img',coord_img_max_limit );
all_inside_img = all(inside_img,2)';
correct = find(all_inside_img);
incorrect = setdiff(1:length(coord_img),correct);
cortex = map_coords(cortex,coord_cortex,correct,incorrect,img,coord_img,cortex_params.mirroring);

end













