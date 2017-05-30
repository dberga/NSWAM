function [  ] = append_text( filepath, text )

    fileID=fopen(filepath,'a');
    fprintf(fileID,'%s',text);
    fclose(fileID);
    
end

