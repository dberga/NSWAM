function [  ] = slink( path1, path2 )

if exist(path2,'file') system(['rm -f' ' ' path2]); end;
try
	system(['ln -rsf ' path1 ' ' path2]);  
catch
	try 
		system(['ln -s ' path1 ' ' path2]);
	catch
		try 
			system(['ln -r ' path1 ' ' path2]);
		catch
			system(['cp ' path1 ' ' path2]);
		end
	end
end

end

