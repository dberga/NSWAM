function [  ] = unpad_images( images_folder, margins_folder )

list_images= listpath(images_folder); 
list_margins= listpath(margins_folder);

for i=1:length(list_images)
    list_images_noext = remove_extension(list_images);
end
for i=1:length(list_margins)
    list_margins_noext = remove_extension(list_margins);
end

for i=1:length(list_images)
    padding_square2original
end

end

