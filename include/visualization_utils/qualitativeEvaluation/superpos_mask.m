function [ supermap ] = superpos_mask( img, mask , pxva)
    if nargin < 3, pxva=40; end

    h=imagesc(img);
      aoicoords_px=getaoicoords_px(mask,pxva,0); %xmin,ymin,xmax,ymax

      linwidth=5;
      if ~isempty(aoicoords_px)
        rectangle('Position',[1 1 size(mask,2)-linwidth size(mask,1)-linwidth],'EdgeColor','r','LineWidth',linwidth);
        rectangle('Position',[aoicoords_px(1) aoicoords_px(2) aoicoords_px(3)-aoicoords_px(1) aoicoords_px(4)-aoicoords_px(2)],'EdgeColor','g','LineWidth',linwidth);
      else
          rectangle('Position',[1 1 size(mask,2)-linwidth size(mask,1)-linwidth],'EdgeColor','r','LineWidth',linwidth);
      end
      set(gca,'position',[0 0 1 1],'units','normalized');
      Sf=getframe(gcf);
      [supermap,map]=frame2im(Sf);
      close all;
end

