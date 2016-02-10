
function [] = saliency(input_image,image_name)

%resize if necessary
%input_image = autoresize(input_image);

%set path parameters
output_prefix = 's';
output_prefix1 = 'iFactor_';
output_prefix2 = 'eCSF_';
output_folder = ['output/' 'output_imgs'];
output_folder_mats = ['output/' 'output_mats'];
output_extension = '.png';
image_name_noext = remove_extension(image_name);
output_image = [output_prefix image_name_noext];
experiment_name =  image_name_noext;
output_recall1 = [output_folder '/' output_prefix1 output_image output_extension];
output_recall2 = [output_folder '/' output_prefix2 output_image output_extension];

channels = {'chromatic', 'chromatic2' ,'intensity'};
struct_path = [ output_folder_mats '/' image_name_noext '_' 'struct' '.mat'];
c1_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{1} ')' '.mat'];
c2_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{2} ')' '.mat'];
c3_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{3} ')' '.mat'];
c1_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{1} ')' '.mat'];
c2_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{2} ')' '.mat'];
c3_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{3} ')' '.mat'];
c1_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{1} ')' '.mat'];
c2_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{2} ')' '.mat'];
c3_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{3} ')' '.mat'];


if exist(output_recall1, 'file') && exist(output_recall2, 'file')
	
	%do nothing
	disp([image_name_noext ' already exists']);

else
	if exist(struct_path, 'file') && exist(c1_iFactorpath, 'file') && exist(c2_iFactorpath, 'file') && exist(c3_iFactorpath, 'file') exist(c1_residualpath, 'file') && exist(c2_residualpath, 'file') && exist(c3_residualpath, 'file') && exist(c1_Lspath, 'file') && exist(c2_Lspath, 'file') && exist(c3_Lspath, 'file')
		%do nothing
		disp([image_name_noext ' mats already exist, computing reconstructing image']);
	else
		%apply neurodynamical model, obtain inverse tranform of iFactors
		[imgin,imgout] = general_NCZLdXim(input_image,experiment_name);

		%no need to compute smap, done in recall
		%fmap = rec_to_smap(imgout);       
		%writeout(fmap,output_image,output_folder,output_extension);

	end

	%reads eCSF and iFactor from outputted .mats and computes the IDWT, mean in time, normalization ... 
	recall(image_name_noext); 

	
end

end

