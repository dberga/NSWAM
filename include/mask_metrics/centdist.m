function [ outdist ] = centdist( map1, map2 )

    [x1,y1]=calc_centroid(mat2gray(map1));
    [x2,y2]=calc_centroid(mat2gray(map2));
    
    outdist=pdist([x1 y1; x2 y2],'euclidean');
end

