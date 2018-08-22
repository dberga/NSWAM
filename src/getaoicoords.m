function [ aoicoords ] = getaoicoords( mask, pxva, stdva )
    if nargin < 3, stdva=2; end
    if nargin < 2, pxva=40; end
    
    
    [y,x]=find(mask(:,:,1)>0);
	
    
    pxstd=pxva*stdva;
    
    xmin=(min(x)-pxstd)/size(mask,2);
    xmax=(max(x)+pxstd)/size(mask,2);
% 	xdist=xmax-xmin;
% 	xmin=xmin-(xdist*0.5);
% 	xmax=xmax+(xdist*0.5);
	
    ymin=(min(y)-pxstd)/size(mask,1);
    ymax=(max(y)+pxstd)/size(mask,1);
%     ydist=ymax-ymin;
% 	ymin=ymin-(ydist*0.5);
% 	ymax=ymax+(ydist*0.5);
	
    aoicoords=[xmin ymin xmax ymax];

end

