function [ loaded_struct_equivalent_path, mfolder,folder_equivalent,iname1,k1 ] = get_samemat( loaded_struct_path )
    loaded_struct_equivalent_path='';
    folder_equivalent='';
    iname1='';k1='';
    
    [lfolder,fname,fextension]=fileparts(loaded_struct_path);
    mfolder=fileparts(lfolder);
    lfolders=listpath_dir(mfolder);
    
    tokens=strsplit(fname,'_struct_gaze');
    iname2=tokens{1};
    tokens2=strsplit(tokens{2},'.mat');
    k2=tokens2{1};
    
    found=0;
    for l=1:length(lfolders)
        lfiles=listpath([mfolder '/' lfolders{l}]);
        for f=1:length(lfiles)
            if findstr('struct',lfiles{f})>0
                tokens=strsplit(lfiles{f},'_struct_gaze');
                iname1=tokens{1};
                tokens2=strsplit(tokens{2},'.mat');
                k1=tokens2{1};
                folder_equivalent=lfolders{l};
                if(get_checksame([mfolder '/' lfolders{l} '/' lfiles{f}],loaded_struct_path) ... %check pre-neurodyn parameters
                    && ~strcmp([mfolder '/' lfolders{l} '/' lfiles{f}],loaded_struct_path) ... %must be not same file
                    && strcmp(iname1,iname2)) %must be same image
                    found=1;
                    loaded_struct_equivalent_path=[mfolder '/' lfolders{l} '/' lfiles{f}];
                    break;
                end
            end
        end
        if found==1
            break;
        end
    end
end

