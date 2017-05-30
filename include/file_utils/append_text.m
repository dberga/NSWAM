function [  ] = append_text( filepath, text )

    fileID=fopen(filepath,'w');
    fprintf(fileID,'%s',text);
    fclose(fileID);
    
end

