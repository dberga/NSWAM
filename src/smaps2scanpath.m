function [ scanpath ] = smaps2scanpath( img_path, smaps )


    [imgfolder,imgname,imgext]=fileparts(img_path);
    img=double(imread(img_path))./255;
    
    if ischar(smaps) %smaps='output_tsotsos/model/gazes'
        gazes_dirs=sort_nat(listpath_dir(smaps));
        %smaps=zeros(size(img,1),size(img,2),length(gazes_dirs));
        for g=1:length(gazes_dirs)
            smaps_array(:,:,g)=double(imread([smaps '/' gazes_dirs{g} '/' imgname '.png']))./255;
        end
        smaps=smaps_array;
    end
    G=size(smaps,3);
    init_yx=[size(img,1),size(img,2)].*0.5;
    scanpath=[init_yx(2) init_yx(1)];
    
    for g=1:G
        smap=smaps(:,:,g);
%         imagesc(smap); colormap(jet);
        [maxval,maxidx]=max(smap(:));
        [y,x]=ind2sub([size(smap,1) size(smap,2)],maxidx);
        scanpath=[scanpath;x,y];
    end

end

