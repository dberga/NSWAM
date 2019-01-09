function [ map ] = superpos_scanpath( img,scanpath,vislimit,pxva )
        if nargin<4, pxva=40; end
        if nargin<3, vislimit=size(scanpath,1); end
        
        scanpath=erase_minamplitude(scanpath,1*pxva);
        
        if size(scanpath,1)>vislimit
            map=visualize_scanpath3(img,scanpath(1:vislimit,:));
        else
            map=visualize_scanpath3(img,scanpath(:,:));
        end

end

