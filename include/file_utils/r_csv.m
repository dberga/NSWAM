function [ cell_out ] = r_csv( csv_path,format,delimiter )

if nargin < 2, format = '%s%s%s%s'; end;
if nargin < 3, delimiter = ','; end;

fid=fopen(csv_path,'r');
cell_read = textscan(fid,format,'delimiter',delimiter);
fclose(fid);

rows=numel(cell_read{1});
cols=numel(cell_read);

cell_out=cell(rows,cols);

[rows,cols]=size(cell_out);
for i=1:rows
     for j=1:cols
         cell_out{i,j}=cell_read{j}{i};
         cell_num=str2double(cell_out{i,j});
         if ~isnan(cell_num)
             cell_out{i,j}=cell_num;
         end
     end
end

end

