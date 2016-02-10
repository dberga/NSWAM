function [newcell] = redim_s_o(matrix_in)

newcell = cell(size(matrix_in,3),size(matrix_in,4));

for s=1:size(matrix_in,3)
	for o=1:size(matrix_in,4)
		newcell{s}{o} = matrix_in(:,:,s,o);
	end
end


end