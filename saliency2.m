
function [] = saliency2(input_image,image_name,conf_struct_path,output_folder,output_folder_mats,output_folder_figs,output_extension)


clear struct wave zli display_plot compute 

if nargin < 7
output_folder = 'output';
output_folder_mats = 'mats'; %output_folder_mats = [output_path 'output_mats'];
output_folder_figs = 'figs'; %output_folder_figs = [output_path 'output_figs'];
output_extension = '.png';

if nargin < 3
	conf_struct_path = 'default_struct.mat';
end

end

[conf_struct_path_folder,conf_struct_path_name,conf_struct_path_ext] = fileparts(conf_struct_path);


%set path parameters
output_prefix = '';

output_subfolder = conf_struct_path_name ;
output_path = [output_folder '/' output_subfolder '/'];
output_folder_imgs = output_path; %output_folder_imgs = [output_path 'output_imgs'];
image_name_noext = remove_extension(image_name);
output_image = [output_prefix image_name_noext];
experiment_name =  image_name_noext;
output_img= [output_folder_imgs '/' output_image output_extension];

%struct params
conf_struct = load(conf_struct_path);
conf_struct = conf_struct.matrix_in;
ds_res = conf_struct.image.autoresize_ds;
nd_res = conf_struct.image.autoresize_nd;
fovear = conf_struct.image.foveate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Load parameters %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%struct=get_default_parameters_NCZLd();
struct=load_default_parameters_NCZLd(conf_struct_path);

struct.image.M = size(input_image,1);
struct.image.N = size(input_image,2);
struct.image.fov_type = 'zli_foveal_distortion';
struct.image.fixationY = round(size(input_image,1)/2);
struct.image.fixationX = round(size(input_image,2)/2);
struct.image.single = experiment_name;
[struct.image.name] = experiment_name;


%resize if necessary
if ds_res ~= -1    
    input_image = autoresize(input_image,ds_res);
else
    input_image = autoresize(input_image);
end

if nd_res ~= 0
    input_image = autoresize_nd(input_image,conf_struct,nd_res);
end

%if image is monochromatic, copy channels (cuidado! mejor solo hacer 1)
if(size(input_image,3)<3)
        input_image(:,:,2) = input_image(:,:,1);
        input_image(:,:,3) = input_image(:,:,1);
end

%foveate function
if fovear ~= 0
    input_image = foveate(input_image,0,conf_struct);
end
    

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


mkdir(output_folder_imgs);
mkdir(output_folder_mats);
mkdir(output_folder_figs);

if exist(output_img, 'file')
	
	%do nothing
	disp([image_name_noext ' already exists']);

else
	if exist(img_struct_path, 'file') && exist(c1_iFactorpath, 'file') && exist(c2_iFactorpath, 'file') && exist(c3_iFactorpath, 'file') && exist(c1_residualpath, 'file') && exist(c2_residualpath, 'file') && exist(c3_residualpath, 'file') && exist(c1_Lspath, 'file') && exist(c2_Lspath, 'file') && exist(c3_Lspath, 'file')
		
        %do nothing, recall afterwards
		
    else
        
        
        input_image = double(input_image);
        devlog(int2str(size(input_image(:,:,1))) );
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Calc scales and orient %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %if n_scales = 0
        [struct.wave.n_scales, struct.wave.ini_scale, struct.wave.fin_scale]= calc_scales(input_image, struct.wave.ini_scale, struct.wave.fin_scale_offset, struct.wave.mida_min, struct.wave.multires); % calculate number of scales (n_scales) automatically

        [struct.wave.n_orient] = calc_norient(input_image,struct.wave.multires,struct.wave.n_scales,struct.zli.n_membr);
        devlog(strcat('Nombre scales a la funci channel_v1_0: ', num2str(struct.wave.n_scales)));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Plot and store  struct %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        store_matrix_givenparams(struct,'struct',struct);

        
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %%%%%%%  stimulus (image) to opponent
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        input_image = get_the_cstimulus(input_image,struct.image.gamma,struct.image.srgb_flag);%! color  to opponent



        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%% Apply neurodynamical %%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
		%apply neurodynamical model, obtain inverse tranform of iFactors
            NCZLd(input_image,experiment_name,struct);
		

    end
    
	disp([image_name_noext ' mats already exist, computing reconstructing image']);
        
    %reads iFactor from outputted .mats and computes the IDWT, mean in time, normalization ... 
    recall(image_name,struct,conf_struct_path); 

	
end

end

