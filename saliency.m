
function [] = saliency(input_image,image_name)

%set output parameters
output_folder = 'output_imgs';
output_image = ['s' image_name];
experiment_name =  image_name;


%apply neurodynamical model, obtain inverse tranform of iFactors
[imgin,imgout] = general_NCZLdXim(input_image,experiment_name);

%normalize each color channel
normalized_color_smap = zeros(size(imgout));
for op=1:3 %for each opponent channel, normalize
  normalized_color_smap(:,:,op) = normalize_channel(imgout(:,:,op));
end



%combine channels and normalize final map
smap = channelcombine(normalized_color_smap);
normalized_smap = normalize_map(smap);
fmap = normalized_smap;
fmap = uint8(fmap);

%plot output
    %figure; 
    %subplot(1,2,1); imshow(uint8(imgin)); 
    %subplot(1,2,2); imshow(fmap); 
    %imagesc(fmap);
        %colormap('gray');

        

%write output image on output folder
imwrite(fmap,[output_folder '/' output_image]);


end

