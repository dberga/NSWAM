function [ aoicoords_px ] = getaoicoords_px( mask, pxva, stdva )
    if nargin < 3, stdva=2; end
    if nargin < 2, pxva=40; end
    
    aoicoords=getaoicoords(mask,pxva,stdva);
    aoicoords_px=aoicoords;
    
    if size(aoicoords,1)>0
        %percentages to pixels
        aoicoords_px(1)=aoicoords(1)*size(mask,2); %xmin
        aoicoords_px(2)=aoicoords(2)*size(mask,1); %ymin
        aoicoords_px(3)=aoicoords(3)*size(mask,2); %xmax
        aoicoords_px(4)=aoicoords(4)*size(mask,1); %ymax
    end
    
end

