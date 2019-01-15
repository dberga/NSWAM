function [ scanpath ] = smaps2scanpath( img_path, smaps_folder )


    [imgfolder,imgname,imgext]=fileparts(img_path);
    img=double(imread(img_path))./255;
    
    gazes_dirs=sort_nat(listpath_dir(smaps_folder));
    %smaps=zeros(size(img,1),size(img,2),length(gazes_dirs));
    for g=1:length(gazes_dirs)
        smaps(:,:,g)=double(imread([smaps_folder '/' gazes_dirs{g} '/' imgname '.png']))./255;
    end
    scanpath=smaps2scanpath(smaps);
end

