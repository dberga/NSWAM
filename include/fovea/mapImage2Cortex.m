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
coord_Y_cortex = (cortex_rows-1-cortex_height_2)*cortex_pix2az_mm;
coord_X_cortex = (cortex_cols-1-cortex_width_2)*cortex_pix2elong_mm;

switch cortex_params.cm_method
    case 'schwartz_monopole'
        [coord_i_eye, coord_j_eye] = schwartz_monopole_inv(coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a);
    case 'schwartz_dipole'
        [coord_i_eye, coord_j_eye] = schwartz_dipole_inv(  coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a,cortex_params.b);
    %case 'dsech_monopole'
    %    [coord_i_eye, coord_j_eye] = dsech_monopole_inv( coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a,cortex_params.eccWidth,cortex_params.isoPolarGrad);
    %case 'dsech_dipole'
    %    [coord_i_eye, coord_j_eye] = dsech_dipole_inv( coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a,cortex_params.b,cortex_params.eccWidth,cortex_params.isoPolarGrad);
    otherwise
        [coord_i_eye, coord_j_eye] = schwartz_monopole_inv(  coord_X_cortex,coord_Y_cortex,cortex_params.lambda,cortex_params.a);
end


img_cols = coord_j_eye*eye_elong2pix+gaze_params.fov_x;
img_rows = coord_i_eye*eye_az2pix+gaze_params.fov_y;
coord_img = round([img_rows;img_cols]);

coord_img_min_limit = repmat([1 1],[numel(cortex) 1]);
coord_img_max_limit = repmat([gaze_params.orig_height gaze_params.orig_width],[numel(cortex) 1]);

inside_img = inside(coord_img',coord_img_max_limit );
all_inside_img = all(inside_img,2)';
correct = find(all_inside_img);
incorrect = setdiff(1:length(coord_img),correct);



cortex = map_coords(cortex,coord_cortex,correct,incorrect,img,coord_img,cortex_params.mirroring);


%cortex(coord_cortex(correct))=img(sub2ind(size_img,i(correct'),j(correct')));
% for ic = coord_cortex
% 	coord_img = [i(ic) j(ic)];
% 	if (inside(coord_img,size_img))
% 		cortex(ic)=img(i(ic),j(ic));
% 	end
% end

end

function [yn] = inside2(coord,min,max)
    
	yn = coord>=min & coord<=max;
end

function [yn] = inside(coord,size)
    %bottom = repmat([0 0],length(size),1);
	yn = coord>=1 & coord<=size;
end

function [yn] = outside2(coord,min,max)
	yn = coord>max | coord<min;
end

function [yn] = outside(coord,size)
	yn = coord>size | coord<[1 1];
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

function [rows, cols] = custom_ind2sub(mat_size, subs)
    rows = zeros(size(subs));
    cols = zeros(size(subs));
    
    for i=1:numel(subs)
        rows(i) = floor(subs(i)/(mat_size(2)+1))+1; 
        cols(i) = mod(subs(i)-1,(mat_size(2)))+1; 
    end
    
     %the +1 and +1 are to adjust to matlab (in matlab, vectors start at 0)
    
    
end





