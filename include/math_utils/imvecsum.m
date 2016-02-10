function image = imvecsum(image_vec)

image = zeros(size(image_vec,1),size(image_vec,2));

for i=1:size(image_vec,3)
	image = image + image_vec(:,:,i);
end

end
