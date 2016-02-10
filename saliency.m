
function [] = saliency(input_image,image_name)

%set output parameters
output_folder = 'output';
output_image = ['sal_' image_name];
experiment_name = 'image_name';
nstripes = 0;

%apply neurodynamical model, obtain inverse tranform of iFactors
[imgin,imgout] = general_NCZLdXim(input_image,experiment_name,nstripes);

%normalize each color channel
normalized_color_smap = zeros(size(imgout));
for op=1:3 %for each opponent channel, normalize
  normalized_color_smap(:,:,op) = normalize_channel(imgout(:,:,op));
end



%combine channels and normalize final map
smap = opponentcombine(normalized_color_smap);
normalized_smap = normalize_map(smap);
fmap = uint8(normalized_smap);

disp(size(smap));
disp(size(normalized_smap));
disp(size(fmap));

%plot output
figure; 
subplot(1,2,1); imshow(uint8(imgin)); 
subplot(1,2,2); imshow(fmap); 
        %imagesc(smap);%colormap('gray');

%write output image on output folder
imwrite(fmap,[output_folder '/' output_image]);


end

