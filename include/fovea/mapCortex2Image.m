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

%coord_img = sub2ind(size(img),coord_i_img, coord_j_img);
coord_img = [1:numel(img)];
[coord_i_img, coord_j_img] = ind2sub(size(img),[1:numel(img)]);





switch cortex_params.cm_method
    case 'schwartz_monopole'
        [coord_j_cortex,coord_i_cortex] = schwartz_monopole( (coord_i_img-gaze_params.fov_y)*eye_pix2az, (coord_j_img-gaze_params.fov_x)*eye_pix2elong,cortex_params.lambda,cortex_params.a);
    case 'schwartz_dipole'
        [coord_j_cortex,coord_i_cortex] = schwartz_dipole( (coord_i_img-gaze_params.fov_y)*eye_pix2az, (coord_j_img-gaze_params.fov_x)*eye_pix2elong,cortex_params.lambda,cortex_params.a,cortex_params.b);
    %case 'dsech_monopole'
    %    [coord_j_cortex,coord_i_cortex] = dsech_monopole( (coord_i_img-gaze_params.fov_y)*eye_pix2az, (coord_j_img-gaze_params.fov_x)*eye_pix2elong,cortex_params.lambda,cortex_params.a,cortex_params.eccWidth,cortex_params.isoPolarGrad);
    %case 'dsech_dipole'
    %    [coord_j_cortex,coord_i_cortex] = dsech_dipole( (coord_i_img-gaze_params.fov_y)*eye_pix2az, (coord_j_img-gaze_params.fov_x)*eye_pix2elong,cortex_params.lambda,cortex_params.a,cortex_params.b,cortex_params.eccWidth,cortex_params.isoPolarGrad);
    otherwise
        [coord_j_cortex,coord_i_cortex] = schwartz_monopole( (coord_i_img-fov_y)*eye_pix2az, (coord_j_img-fov_x)*eye_pix2elong,cortex_params.lambda,cortex_params.a);
end

j = round((coord_j_cortex*cortex_elong2pix_mm)+cortex_width_2+1);
i = round((coord_i_cortex*cortex_az2pix_mm)+cortex_height_2+1); 
coord_cortex = [i;j];

coord_cortex_min_limit = repmat([1 1],[numel(img) 1]);
coord_cortex_max_limit = repmat([gaze_params.orig_height gaze_params.orig_width],[numel(img) 1]);

inside_cortex = inside(coord_cortex',coord_cortex_max_limit );
all_inside_cortex = all(inside_cortex,2)';
correct = find(all_inside_cortex);
incorrect = setdiff(1:length(coord_cortex),correct);
%correct = find(all(inside(coord_cortex',repmat(size(cortex),[numel(img) 1]) ),2)');

%img(coord_img(correct))=cortex(sub2ind(size(cortex),i(correct'),j(correct')));
img = map_coords(img,coord_img,correct,incorrect,cortex,coord_cortex,cortex_params.mirroring);


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


function [map1] = map_coords(map1,coord_map1,idx_inside,idx_outside,map2,coord_map2,mirroring)


    size_map2 = [size(map2,1) size(map2,2)];
    i = coord_map2(1,:);
    j = coord_map2(2,:);
    
    coords_i_inside = i(idx_inside');
    coords_j_inside = j(idx_inside');
    coords_inside = sub2ind(size_map2,coords_i_inside,coords_j_inside);

    map1(coord_map1(idx_inside))=map2(coords_inside);
    
    
    %mirroring here
    if mirroring == 1
        coords_i_outside = i(idx_outside');
            coords_i_outside = inmod(coords_i_outside,1,size_map2(1));
        coords_j_outside = j(idx_outside');
            coords_j_outside = inmod(coords_j_outside,1,size_map2(2));
        coords_outside = sub2ind(size_map2,coords_i_outside,coords_j_outside);
        map1(coord_map1(idx_outside))=map2(coords_outside);
    end
    
end

function nn = inmod(n,l1,l2)

    n(~isfinite(n))=1; 
    nn = n;
    
    modif1 = abs(n) > l2;
    modif2 = n < l1;
    
    odd = mod(ceil(n/l2),2); odd = logical(odd);
    modif4 = modif1 & odd | modif2 & ~odd;
    modif5 = modif1 & ~odd | modif2 & odd;
    
    %negatives go reversed
    nn(modif2) = abs(nn(modif2));
    
    %transform plane coordinates outside the map
    nn(modif1)=mod(nn(modif1),l2); 
    
    %for odd planes outside, do not apply fliping
    nn(modif4)=nn(modif4);
    
    %for even planes outside, apply fliping
    nn(modif5) = l2-(nn(modif5));
    
    nn(find(nn==0))=1;
    
    
end




