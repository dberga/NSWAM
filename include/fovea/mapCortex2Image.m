function [img] = mapCortex2Image(cortex,cortex_params,gaze_params)



cortex_params.cortex_height = size(cortex,1); 
cortex_params.cortex_width = size(cortex,2); 
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

[coord_i_img, coord_j_img] = ind2sub(size(img),[1:numel(img)]);
coord_img = sub2ind(size(img),coord_i_img, coord_j_img);




switch cortex_params.cm_method
    case 'schwartz_monopole'
        [coord_j_cortex,coord_i_cortex] = schwartz_monopole( (coord_i_img-gaze_params.fov_y)*eye_pix2az, (coord_j_img-gaze_params.fov_x)*eye_pix2elong,cortex_params.lambda,cortex_params.a);
    case 'schwartz_dipole'
        [coord_j_cortex,coord_i_cortex] = schwartz_dipole( (coord_i_img-gaze_params.fov_y)*eye_pix2az, (coord_j_img-gaze_params.fov_x)*eye_pix2elong,cortex_params.lambda,cortex_params.a,cortex_params.b);
    case 'dsech_monopole'
        [coord_j_cortex,coord_i_cortex] = dsech_monopole( (coord_i_img-gaze_params.fov_y)*eye_pix2az, (coord_j_img-gaze_params.fov_x)*eye_pix2elong,cortex_params.lambda,cortex_params.a,cortex_params.eccWidth,cortex_params.isoPolarGrad);
    case 'dsech_dipole'
        [coord_j_cortex,coord_i_cortex] = dsech_dipole( (coord_i_img-gaze_params.fov_y)*eye_pix2az, (coord_j_img-gaze_params.fov_x)*eye_pix2elong,cortex_params.lambda,cortex_params.a,cortex_params.b,cortex_params.eccWidth,cortex_params.isoPolarGrad);
    otherwise
        [coord_j_cortex,coord_i_cortex] = schwartz_monopole( (coord_i_img-fov_y)*eye_pix2az, (coord_j_img-fov_x)*eye_pix2elong,cortex_params.lambda,cortex_params.a);
end

j = round((coord_j_cortex*cortex_elong2pix_mm)+cortex_width_2+1);
i = round((coord_i_cortex*cortex_az2pix_mm)+cortex_height_2+1);



coord_cortex = [i;j];
correct = find(all(inside(coord_cortex',repmat(size(cortex),[numel(img) 1]) ),2)');

img(coord_img(correct))=cortex(sub2ind(size(cortex),i(correct'),j(correct')));



% for ic = coord_img
% 	coord_cortex = [i(ic) j(ic)];
% 	if (inside(coord_cortex,size_cortex))
% 		img(ic)=cortex(i(ic),j(ic));
% 	end
% end

end

function [yn] = inside(coord,size)
	yn = coord>0 & coord<=size;
end


