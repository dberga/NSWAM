function [ map ] = superpos_scanpath( img,scanpaths,vislimit,pxva,marker_colors )
        if nargin<5,
%             for s=1:length(scanpaths) 
%                 marker_colors{s}=[1 0 0;1 0 0; 1 0 0; 1 0 0; 0 0 0 ];
%             end
            marker_colors{1}=[0 0 0;0 0 0; 0 0 0; 0 0 0; 0 0 0 ];
            marker_colors{2}=[1 0 0;1 0 0; 1 0 0; 1 0 0; 0 0 0 ];
            marker_colors{3}=[1 0 1;1 0 1; 1 0 1; 1 0 1; 0 0 0 ];
        end
        if nargin<4, pxva=40; end
        if nargin<3, 
            for s=1:length(scanpaths)
                vislimits{s}=size(scanpaths{s},1);
            end
        end
        fig=imagesc(img);
        for s=1:length(scanpaths)
                tpf=300;
                f=1:size(scanpaths{s},1);
                scanpath_times{s}(:,1)=tpf.*f - tpf;
                scanpath_times{s}(:,2)=tpf.*f;
                
            hold on
            if size(scanpaths{s},1)>vislimits{s}
                map=visualize_scanpath4(img,scanpaths{s}(1:vislimits{s},:),scanpath_times{s},marker_colors{s},false);
            else
                map=visualize_scanpath4(img,scanpaths{s}(:,:),scanpath_times{s},marker_colors{s},false);
            end
            hold off
        end
        [map,~]= frame2im(getframe);   
end


