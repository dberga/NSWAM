function [] = w_csv(cell_in, csv_path) 
 
	fid=fopen(csv_path,'wt');
	[rows,cols]=size(cell_in);

	for i=1:rows

	      fprintf(fid,'%s,',cell_in{i,1:end-1});

	      fprintf(fid,'%s\n',cell_in{i,end});

	end

	fclose(fid);


end

