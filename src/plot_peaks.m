
function [] = plot_peaks(smap,struct)
        if nargin<2,
            struct.file_params.name='image';
        end
       [peaks,locs]=findpeaks(smap(:));
       [peakX,peakY]=ind2sub(size(smap),locs); 
       %hold on
       %h1=surf(fliplr(smap),'edgecolor','none');
       %view(-170,37)
       h2=image_3D(smap,2,jet,jet); view(14,40);
       cb=colorbar;
       set(cb,'position',[.10 .75 .05 .2]); caxis([0 1]); 
       axis off;
       %hold off
       %dcm_obj = datacursormode();
       %createDatatip(dcm_obj, h2, [peakX(2), peakY(2),peaks(2)]);
       mkdir('figs/smap');
       saveas(gcf,['figs/smap/' struct.file_params.name '_' 'smap' '.png']);
end
