function [output_name] = remove_extension(input_name)

[pathstr, name, ext] = fileparts(input_name);

output_name = [pathstr name];

end
