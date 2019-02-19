function [ listpath] = dirpath2listpath( dirpath)
    listpath = cell(length(dirpath),1); %be careful with . and ..
    for i=1:length(dirpath)
        listpath{i} = dirpath(i).name;
    end

end

