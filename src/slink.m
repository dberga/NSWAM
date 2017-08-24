function [  ] = slink( path1, path2 )

if exist(path2,'file') system(['rm -f' ' ' path2]); end;
system(['ln -sf ' path1 ' ' path2]);  

end

