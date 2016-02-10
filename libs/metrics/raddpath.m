function [] = raddpath(path) %recursive addpath
    
maindir = dir(path);

%travel each subfolder recursively
for i=3:length(maindir)
    spath = [path '/' maindir(i).name];
    if exist(spath,'dir')==7
        addpath(spath);
        raddpath(spath);
    end
end


end


%function [] = raddpath(path,format)

%maindir = dir(path);

%add files with such format
%files = dir([path '/' '*.' format]);
%for j=3:length(files)
     %addpath([path '/' files(j).name]);
%end

%travel each subfolder recursively
%for i=3:length(maindir)
%    spath = [path '/' maindir(i).name];
%    if exist(spath,'dir')==7
%        addpath(spath);
%        raddpath(spath,format);
%    end
%end

%end

