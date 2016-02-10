function [strct]=load_default_parameters_NCZLd(mat_path)


strct = load(mat_path);
strct = strct.matrix_in;

end

%fer amb csv