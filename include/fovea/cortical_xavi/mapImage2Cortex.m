function [cortex] = mapImage2Cortex(img,img_diag_angle,cortex_width, fov_x, fov_y)

size_img = [size(img,1) size(img,2)];


cortex_max_elong_mm = 120;
cortex_max_az_mm = 60;
cortex_height = round((cortex_max_az_mm/cortex_max_elong_mm)*cortex_width);

img_height = size_img(1); 
img_width = size_img(2); 
cortex_width_2 = cortex_width/2; 
cortex_height_2 = cortex_height/2;


cortex = zeros(cortex_height,cortex_width);

size_cortex = size(cortex);




cortex_pix2elong_mm = cortex_max_elong_mm/cortex_width;
cortex_pix2az_mm = cortex_max_az_mm/cortex_height;

img_diag_pix = sqrt(img_width*img_width+img_height*img_height);

img_elong_angle = img_diag_angle*img_width/img_diag_pix;
img_az_angle = img_diag_angle*img_height/img_diag_pix;

eye_elong2pix = img_width/img_elong_angle;
eye_az2pix = img_height/img_az_angle;

[coord_i_cortex, coord_j_cortex] = ind2sub(size(cortex),[1:numel(cortex)]);
coord_cortex = sub2ind(size_cortex,coord_i_cortex, coord_j_cortex);

[coord_i_eye, coord_j_eye] = cortex2eye( (coord_j_cortex-1-cortex_width_2)*cortex_pix2elong_mm, (coord_i_cortex-1-cortex_height_2)*cortex_pix2az_mm);


j = round(coord_j_eye*eye_elong2pix+fov_x);
i = round(coord_i_eye*eye_az2pix+fov_y);

coord_img = [i;j];
correct = find(all(inside(coord_img',repmat(size_img,[numel(cortex) 1]) ),2)');


cortex(coord_cortex(correct))=img(sub2ind(size_img,i(correct'),j(correct')));

% for ic = coord_cortex
% 	coord_img = [i(ic) j(ic)];
% 	if (inside(coord_img,size_img))
% 		cortex(ic)=img(i(ic),j(ic));
% 	end
% end

end

function [yn] = inside(coord,size)
	yn = coord>0 & coord<=size;
end
