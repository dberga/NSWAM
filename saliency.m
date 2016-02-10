
function [] = saliency(input_image,image_name,conf_struct_path)

if nargin < 3
	conf_struct_path = 'default_struct.mat';
end


conf_struct = load(conf_struct_path);
conf_struct = conf_struct.matrix_in;
ds_res = conf_struct.compute.autoresize_ds;
nd_res = conf_struct.compute.autoresize_nd;

%resize if necessary
if ds_res ~= 0
    input_image = autoresize(input_image,ds_res);
end

if nd_res ~= 0
    input_image = autoresize_nd(input_image,conf_struct,nd_res);
end

%if image is monochromatic, copy channels
if(size(input_image,3)<3)
        input_image(:,:,2) = input_image(:,:,1);
        input_image(:,:,3) = input_image(:,:,1);
end


%set path parameters
output_prefix = '';
output_folder = 'output';
output_subfolder = remove_extension(conf_struct_path) ;
output_path = [output_folder '/' output_subfolder '/'];
output_folder_imgs = [output_path 'output_imgs'];
output_folder_mats = [output_path 'output_mats'];
output_folder_figs = [output_path 'output_figs'];
output_extension = '.png';
image_name_noext = remove_extension(image_name);
output_image = [output_prefix image_name_noext];
experiment_name =  image_name_noext;
output_img= [output_folder_imgs '/' output_image output_extension];

channels = {'chromatic', 'chromatic2' ,'intensity'};
img_struct_path = [ output_folder_mats '/' image_name_noext '_' 'struct' '.mat'];
c1_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{1} ')' '.mat'];
c2_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{2} ')' '.mat'];
c3_iFactorpath = [ output_folder_mats '/' image_name_noext '_' 'iFactor' '_channel(' channels{3} ')' '.mat'];
c1_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{1} ')' '.mat'];
c2_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{2} ')' '.mat'];
c3_residualpath = [ output_folder_mats '/' image_name_noext '_' 'residual' '_channel(' channels{3} ')' '.mat'];
c1_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{1} ')' '.mat'];
c2_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{2} ')' '.mat'];
c3_Lspath = [ output_folder_mats '/' image_name_noext '_' 'Ls' '_channel(' channels{3} ')' '.mat'];


if exist(output_img, 'file')
	
	%do nothing
	disp([image_name_noext ' already exists']);

else
	if exist(img_struct_path, 'file') && exist(c1_iFactorpath, 'file') && exist(c2_iFactorpath, 'file') && exist(c3_iFactorpath, 'file') && exist(c1_residualpath, 'file') && exist(c2_residualpath, 'file') && exist(c3_residualpath, 'file') && exist(c1_Lspath, 'file') && exist(c2_Lspath, 'file') && exist(c3_Lspath, 'file')
		
        %do nothing
		disp([image_name_noext ' mats already exist, computing reconstructing image']);
    else
        
        mkdir(output_folder_mats);
        mkdir(output_folder_figs);
		%apply neurodynamical model, obtain inverse tranform of iFactors
		general_NCZLdXim(input_image,experiment_name,conf_struct_path);

		%no need to compute smap, done in recall
		%fmap = rec_to_smap(imgout);       
		%writeout(fmap,output_image,output_folder,output_extension);

    end
    
    mkdir(output_folder_imgs);
	%reads iFactor from outputted .mats and computes the IDWT, mean in time, normalization ... 
	recall(image_name,conf_struct_path); 

	
end

end

