function [ map ] = superpos_scanpath( img,scanpaths,vislimit,pxva,marker_colors )
        if nargin<5,
%             for s=1:length(scanpaths) 
%                 marker_colors{s}=[1 0 0;1 0 0; 1 0 0; 1 0 0; 0 0 0 ];
%             end


    marker_colors{1}=[0 0 0;0 0 0; 0 0 0; 0 0 0; 1 1 1];
    marker_colors{2}=[ .31 .59 .80;.31 .59 .80;.31 .59 .80; .31 .59 .80; 0 0 0 ];
    marker_colors{3}=[1 0 1;1 0 1; 1 0 1; 1 0 1; 0 0 0 ];
    marker_colors{4}=[.58 0 .83;.58 0 .83; .58 0 .83; .58 0 .83; 0 0 0 ];
    marker_colors{5}=[.83 0 .83;.83 0 .83;.83 0 .83; .83 0 .83; 0 0 0 ];
    marker_colors{6}=[0 1 1;0 1 1;0 1 1; 0 1 1; 0 0 0 ];
    marker_colors{7}=[1 0 0;1 0 0; 1 0 0; 1 0 0; 0 0 0 ];
%             marker_colors{1}=[0 0 0;0 0 0; 0 0 0; 0 0 0; 0 0 0 ];
%             marker_colors{2}=[1 0 0;1 0 0; 1 0 0; 1 0 0; 0 0 0 ];
%             marker_colors{3}=[1 0 1;1 0 1; 1 0 1; 1 0 1; 0 0 0 ];
%             marker_colors{4}=[1 0 1;1 1 0; 1 0 1; 1 0 1; 0 0 0 ];
%             marker_colors{5}=[1 0 1;0 1 1; 1 0 1; 1 0 1; 0 0 0 ];
        end
        if nargin<4, pxva=40; end
        if nargin<3, 
            for s=1:length(scanpaths)
                vislimit(s)=size(scanpaths{s},1);
            end
        elseif length(vislimit) < length(scanpaths)
            vislimit_orig=vislimit;
            for s=1:length(scanpaths)
                vislimit(s)=vislimit_orig;
            end
        end
        fig=imagesc(img);
        for s=1:length(scanpaths)
                tpf=300;
                f=1:size(scanpaths{s},1);
                scanpath_times{s}(:,1)=tpf.*f - tpf;
                scanpath_times{s}(:,2)=tpf.*f;
                
            hold on
            if size(scanpaths{s},1)>vislimit(s)
                map=visualize_scanpath4(img,scanpaths{s}(1:vislimit(s),:),scanpath_times{s},marker_colors{s},false);
            else
                map=visualize_scanpath4(img,scanpaths{s}(:,:),scanpath_times{s},marker_colors{s},false);
            end
            hold off
        end
        [map,~]= frame2im(getframe);   
end


