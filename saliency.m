
function [] = saliency(input_image,image_name)


%set output parameters
output_prefix = 's';
output_folder = ['output/' 'output_imgs'];
output_folder_mats = ['output/' 'output_mats'];
output_extension = '.png';
image_name_noext = remove_extension(image_name);
output_image = [output_prefix image_name_noext];
experiment_name =  image_name_noext;


%apply neurodynamical model, obtain inverse tranform of iFactors
[imgin,imgout] = general_NCZLdXim(input_image,experiment_name);

%no need to compute smap, done in recall
%fmap = rec_to_smap(imgout);       
%writeout(fmap,output_image,output_folder,output_extension);

%reads eCSF and iFactor from outputted .mats and computes the IDWT, mean in time, normalization ... 
recall(image_name_noext); 

end

