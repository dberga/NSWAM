function [ stringout ] = txt2tring( txtpath )

%     stringcells=textread(txtpath);
%     stringout=strjoin(stringcells,'\n');

    fileID = fopen(txtpath,'r');
    [stringcell,~] = textscan(fileID, '%s');
    stringout=strjoin(stringcell{1},'\n');
    fclose(fileID);
end

