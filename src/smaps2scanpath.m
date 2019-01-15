function [ scanpath ] = smaps2scanpath( smaps )


    
        
    G=size(smaps,3);
    init_yx=[size(smaps,1),size(smaps,2)].*0.5;
    scanpath=[init_yx(2) init_yx(1)];
    
    for g=1:G
        smap=smaps(:,:,g);
%         imagesc(smap); colormap(jet);
        [maxval,maxidx]=max(smap(:));
        [y,x]=ind2sub([size(smap,1) size(smap,2)],maxidx);
        scanpath=[scanpath;x,y];
    end
end

