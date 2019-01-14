function [ scanpath ] = smaps2scanpath( img_path, smaps_folder )
    gazes_dirs=listpath_dir(smaps_folder);
    [imgfolder,imgname,imgext]=fileparts(img_path);
    img=double(imread(img_path))./255;
    init_yx=[size(img,1),size(img,2)].*0.5;
    scanpath=[init_yx(2) init_yx(1)];
    for g=1:length(gazes_dirs)
        smap=double(imread([smaps_folder '/' gazes_dirs{g} '/' imgname '.png']))./255;
%         imagesc(smap); colormap(jet);
        [maxval,maxidx]=max(smap(:));
        [y,x]=ind2sub([size(smap,1) size(smap,2)],maxidx);
        scanpath=[scanpath;x,y];
    end

end

