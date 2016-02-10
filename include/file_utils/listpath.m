function [listfiles] = listpath(path) %recursive addpath
    
maindir = dir(path);
listfiles = cell(1,length(maindir)-3);

%travel each subfolder recursively
for i=3:length(maindir)
    fname = maindir(i).name;
    spath = [path '/' fname];
    
%     if exist(spath,'dir')==7
%         recur = listpath(spath);
%         recur = recur(~cellfun(@isempty, recur));
%         listfiles = {listfiles recur};
%     else
    if exist(spath,'file')==2
        listfiles{i-2}=fname;
    end
end

listfiles = listfiles(~cellfun(@isempty, listfiles));

end

