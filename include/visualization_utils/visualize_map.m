function [  h ] = visualize_map(map1,map2  )
    map3=imfuse(map1,map2);
    h=imagesc(map3);
end

