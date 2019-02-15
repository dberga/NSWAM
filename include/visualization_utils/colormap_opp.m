function [  ] = colormap_opp( c )
    
switch c
    case 1 %a
        cmap_red=hsv2rgb([repmat(0/360,1,32)' repmat(1,1,32)' (1/32:1/32:1)']);
        cmap_green=hsv2rgb([repmat(120/360,1,32)' repmat(1,1,32)' (1/32:1/32:1)']);
        cmap_rg=[flipud(cmap_green);cmap_red];
        colormap(cmap_rg);
        colormap(redgreencmap);
%         colormap(rgcmap(0,64));
    case 2 %b
        cmap_blue=hsv2rgb([repmat(240/360,1,32)' repmat(1,1,32)' (1/32:1/32:1)']);
        cmap_yellow=hsv2rgb([repmat(60/360,1,32)' repmat(1,1,32)' (1/32:1/32:1)']);
        cmap_by=[flipud(cmap_blue);cmap_yellow];
        colormap(cmap_by);
%         colormap(parula);
%         colormap(bycmap(0,64)); 
        
    case 3 %L
        colormap(gray);
        
end
    
    
end

