function [ map ] = superpos_scanpath( img,scanpath,vislimit,pxva,marker_color,printtext )
        if nargin<6,printtext=true; end
        if nargin<5,marker_color=[1 0 0;1 0 0; 1 0 0; 1 0 0; 0 0 0 ];  end
        if nargin<4, pxva=40; end
        if nargin<3, vislimit=size(scanpath,1); end
        
        %scanpath=erase_minamplitude(scanpath,1*pxva);
        
        if size(scanpath,2) > 3
            scanpath_times=scanpath(:,3:4);
        else
            tpf=300;
            f=1:size(scanpath,1);
            scanpath_times(:,1)=tpf.*f - tpf;
            scanpath_times(:,2)=tpf.*f;
        end
        if size(scanpath,1)>vislimit
            map=visualize_scanpath3(img,scanpath(1:vislimit,:),scanpath_times,marker_color,printtext);
        else
            map=visualize_scanpath3(img,scanpath(:,:),scanpath_times,marker_color,printtext);
        end

end

