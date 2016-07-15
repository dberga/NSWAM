function [cortex] = mapImage2Cortex(img,img_diag_angle,cortex_width, fov_x, fov_y,lambda,e0)

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

[coord_i_eye, coord_j_eye] = cortex2eye( (coord_j_cortex-1-cortex_width_2)*cortex_pix2elong_mm, (coord_i_cortex-1-cortex_height_2)*cortex_pix2az_mm,lambda,e0);


j = round(coord_j_eye*eye_elong2pix+fov_x);
i = round(coord_i_eye*eye_az2pix+fov_y);

coord_img = [i;j];
correct = find(all(inside(coord_img',repmat(size_img,[numel(cortex) 1]) ),2)');
incorrect = setdiff(1:length(coord_img),correct);

cortex = map_coords(cortex,coord_cortex,correct,incorrect,img,coord_img);
%cortex(coord_cortex(correct))=img(sub2ind(size_img,i(correct'),j(correct')));

% for ic = coord_cortex
% 	coord_img = [i(ic) j(ic)];
% 	if (inside(coord_img,size_img))
% 		cortex(ic)=img(i(ic),j(ic));
% 	end
% end

end

function [yn] = inside(coord,size)
    %bottom = repmat([0 0],length(size),1);
	yn = coord>0 & coord<=size;
end

function [yn] = outside(coord,size)
	yn = coord>size | coord<=[0 0];
end


function [map] = map_coords(map,coord_map,idx_inside,idx_outside,img,coord_img)


    size_img = [size(img,1) size(img,2)];
    i = coord_img(1,:);
    j = coord_img(2,:);
    
    coords_i_inside = i(idx_inside');
    coords_j_inside = j(idx_inside');
    coords_inside = sub2ind(size_img,coords_i_inside,coords_j_inside);
    map(coord_map(idx_inside))=img(coords_inside);
    
    %mirroring here
    coords_i_outside = i(idx_outside');
        coords_i_outside = inmod(coords_i_outside,1,size_img(1));
    coords_j_outside = j(idx_outside');
        coords_j_outside = inmod(coords_j_outside,1,size_img(2));
    coords_outside = sub2ind(size_img,coords_i_outside,coords_j_outside);
    map(coord_map(idx_outside))=img(coords_outside);
    
    
end

function nn = inmod(n,l1,l2)

    nn = n;
    modif1 = n > l2;
    modif2 = n < l1;
    modif3 = (modif1 | modif2);
    
    odds = mod(ceil(n/l2),2); odds = logical(odds);
    modif4 = modif3 & odds; %odds outside
    modif5 = modif3 & ~odds; %even outside
    
    %transform values outside the map
    nn(modif3)=mod(n(modif3),l2)+1; 
    
    %for odd numbers outside, do not apply fliping
        %nothing
    
    %for even numbers outside, apply fliping
    nn(modif5) = l2-(nn(modif5) -1);
    
    
    
end





