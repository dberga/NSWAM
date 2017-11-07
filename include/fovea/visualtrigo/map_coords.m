function [map1] = map_coords(map1,coord_map1,idx_inside,idx_outside,map2,coord_map2,mirroring)


    size_map2 = [size(map2,1) size(map2,2)];
    i = coord_map2(1,:);
    j = coord_map2(2,:);
    
    coords_i_inside = i(idx_inside');
    coords_j_inside = j(idx_inside');
    %coords_inside = sub2ind(size_map2,coords_i_inside,coords_j_inside);

    map3=interp2(map2,j,i);
%     map1(coord_map1(idx_inside))=map2(coords_inside);
    map1=reshape(map3,size(map1));
    
    %mirroring here
    if mirroring == 1
        coords_i_outside = floor(i(idx_outside'))+1;
            coords_i_outside = inmod(coords_i_outside,1,size_map2(1));
        coords_j_outside = floor(j(idx_outside'))+1;
            coords_j_outside = inmod(coords_j_outside,1,size_map2(2));
        coords_outside = sub2ind(size_map2,coords_i_outside,coords_j_outside);
        map1(coord_map1(idx_outside))=map2(coords_outside);
    end
    
end