function [newcell] = redim_t_s_o(matrix_in)

newcell = cell(length(matrix_in),1);

for t=1:size(matrix_in,1)
	newcell{t} = redim_s_o(matrix_in{t});
end


end