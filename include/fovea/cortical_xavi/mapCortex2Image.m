function [img] = mapCortex2Image(cortex,img_diag_angle,img_width, img_height, fov_x, fov_y)

size_cortex = size(cortex);

cortex_height = size_cortex(1); 
cortex_width = size_cortex(2); 
cortex_height_2 = cortex_height/2; 
cortex_width_2 = cortex_width/2; 


img = zeros(img_height,img_width);

size_img = size(img);

cortex_max_elong_mm = 108;
cortex_max_az_mm = 45;


cortex_elong2pix_mm = cortex_width/cortex_max_elong_mm;
cortex_az2pix_mm = cortex_height/cortex_max_az_mm;

img_diag_pix = sqrt(img_width*img_width+img_height*img_height);

img_elong_angle = img_diag_angle*img_width/img_diag_pix;
img_az_angle = img_diag_angle*img_height/img_diag_pix;

eye_pix2elong = img_elong_angle/img_width;
eye_pix2az = img_az_angle/img_height;

[coord_i_img, coord_j_img] = ind2sub(size(img),[1:numel(img)]);
coord_img = sub2ind(size_img,coord_i_img, coord_j_img);

[coord_j_cortex,coord_i_cortex] = eye2cortex( (coord_i_img-fov_y)*eye_pix2az, (coord_j_img-fov_x)*eye_pix2elong);


j = round((coord_j_cortex*cortex_elong2pix_mm)+cortex_width_2+1);
i = round((coord_i_cortex*cortex_az2pix_mm)+cortex_height_2+1);

coord_cortex = [i;j];
correct = find(all(inside(coord_cortex',repmat(size_cortex,[numel(img) 1]) ),2)');
img(coord_img(correct))=cortex(sub2ind(size_cortex,i(correct'),j(correct')));

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
