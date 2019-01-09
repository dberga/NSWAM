function [  ] = colormap_opp( c )
    
switch c
    case 1 %a
        colormap(redgreencmap);
    case 2 %b
        colormap(parula);
    case 3 %L
        colormap(gray);
end
    
    
end

