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
    
    for l=1:length(lfolders)
        lfiles=listpath([mfolder '/' lfolders{l}]);
        for f=1:length(lfiles)
            if findstr('struct',lfiles{f})>0
                tokens=strsplit(lfiles{f},'_struct_gaze');
                iname1=tokens{1};
                tokens2=strsplit(tokens{2},'.mat');
                k1=tokens2{1};
                folder_equivalent=lfolders{l}; 
                folder_current=[mfolder '/' lfolders{l} '/' lfiles{f}];
                if strcmp(iname1,iname2) %must be same image
                    if ~strcmp(folder_current,loaded_struct_path) %must be not same file
                        try
                            if get_checksame(folder_current,loaded_struct_path) %check pre-neurodyn parameters
                                loaded_struct_equivalent_path=folder_current;
                                return;
                            end
                        end
                    end
                end
            end
        end
    end
end

