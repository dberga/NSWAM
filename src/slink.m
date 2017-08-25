function [  ] = slink( path1, path2 )

if exist(path2,'file') system(['rm -f' ' ' path2]); end;
try
	system(['ln -rsf ' path1 ' ' path2]);  
catch
	system(['ln -s ' path1 ' ' path2]);
end

end

