
function [  ] = plot_dynamics_spec( images_list, mats_path, gaze, masks_path)

addpath(genpath('include'));
addpath(genpath('src'));

model_name='no_cortical_config_b1_15';

if nargin < 1, 
	%images_list = {'input_sid4vam/d1Bvs4BrTGwBB1.png','input_sid4vam/d1Bvs4BrTGwBB0p83333.png','input_sid4vam/d1Bvs4BrTGwBB0p66667.png','input_sid4vam/d2Bvs4BrTGwBB0p5.png','input_sid4vam/d2Bvs4BrTGwBB0p33333.png','input_sid4vam/d2Bvs4BrTGwBB0p16667.png','input_sid4vam/d2Bvs4BrTGwBB0.png'};
	
	images_path='input_sid4vam';
	list_path='/home/dberga/repos/datasets/SID4VAM/sid4vam_rawdata/list.csv';
    N=230;
	list=r_csv(list_path,repmat('%s',1,N));
	list_files={list{2,:}};
	contrast_list=cell2mat({list{5,:}});
	stim_values=cell2mat({list{6,:}});

	blocks={'fv1','fv2','fv3','fv4','fv5','vs1','vs2','vs3','vs4','vs5','vs6','vs7','vs8','vs9','vs10'};
	tasktype={'fv','fv','fv','fv','fv','vs','vs','vs','vs','vs','vs','vs','vs','vs','vs'};
	blocks_cond={{''},{'single','superimposed'},{''},{''},{'dissimilar','similar'},{'feature','conjunctive','feature-absent','conjunctive-absent'},{'presence','absence'},{'RMS=0.9','RMS=1.1'},{'Red Target & Grey Background','Red Target & Red Background','Blue Target & Grey Background','Blue Target & Red Background'},{'Black Target & White Background','White Target & Black Background'},{''},{''},{'homogeneous','tilted-right','flanking'},{'linear','nonlinear at 10º','nonlinear at 20º','nonlinear at 90º'},{'steep','steepest','steep-right'}};
	block_list_str={list{3,:}};
	block_cond_list_str={list{4,:}};
	block_cond_list= blockcondstr2blockcond( block_cond_list_str,  blocks_cond);
	block_list= blockstr2block( block_list_str,  blocks);
	blocks_labels={{'Corner Angle (º)','Corner Height (deg)'},{'First Segment Angle Contrast, \Delta\Phi (º)','Second Segment Angle Contrast,  \Delta\Phi (º)' }, {'Segment Spacing (deg)','Bar length (deg)'},{'Contour Length (deg)'}, {'Group Distance (deg)'},{'Set Size (#)'}, {'Scale (deg)','Set Size (#)'},{'Roughness (\beta)'}, {'Saturation Contrast, \DeltaS(HSL)','theta, \theta (º)'}, {'Lightness Contrast, \DeltaL(HSL)'}, {'Size (deg)','Scaling Factor'}, {'Orientation Contrast, \Delta\Phi (º)'}, {'Orientation Contrast to 1st conf, \Delta\Phi (º)','Orientation Contrast to 2st conf,homogeneous, \Delta\Phi (º)','Orientation Contrast to 2st conf,tilted-right, \Delta\Phi (º)','Orientation Contrast to 2st conf,flanking, \Delta\Phi (º)'}, {'Orientation Contrast, \Delta\Phi (º)'}, {'Orientation Contrast to 1st conf, \Delta\Phi (º)','Orientation Contrast to 2st conf, \Delta\Phi (º)'}};
	blocks_names={'Corner Salience','Visual Segmentation - Angle','Visual Segmentation - Spacing','Contour Integration','Perceptual Grouping','Feature Search','Search Asymmetries','Rough Surface','Color Contrast','Brightness Contrast','Size Contrast','Angle Contrast','Heterogeneity','Linearity','Categorization'};
	
	blocks_wanted=[10];
	blocks_cond_wanted=[1];
	for b=1:length(blocks_wanted), b=blocks_wanted(b); %for b=1:length(blocks)
		disp(blocks{b});
		bc=blocks_cond_wanted; %for bc=1:max(block_cond_list(block_list==b))
		fileslist={list_files{block_list==b & block_cond_list==bc}};
		corder=contrast_list(block_list==b & block_cond_list==bc);
		
		for c=1:length(corder) %for i=1:length(fileslist)
			images_list{c}=[images_path '/' fileslist{c} '.png'];
		end
	end
end
if nargin < 2, mats_path=['mats_sid4vam/' model_name ]; end
if nargin < 3, gaze = 1; end
if nargin < 4, masks_path=['/home/dberga/repos/datasets/SID4VAM/sid4vam_rawdata/mmaps']; end

for i=1:length(images_list)
	[image_folder,image_name_noext,ext]=fileparts(images_list{i});
	masks_list{i}=[masks_path '/' image_name_noext ext];
end

channels={'chromatic','chromatic2','intensity'};



for i=1:length(images_list)

	[filepath,name,ext] = fileparts(images_list{i});
	struct_path=[mats_path '/' name '_struct_gaze' num2str(gaze) '.mat'];

	mat=load(struct_path);
	struct=mat.matrix_in;

	mask=imread(masks_list{i});
	aoicoords=getaoicoords(mask,35,0);

	for c=1:length(channels)
		iFactor_channel_path=[mats_path '/' name '_iFactor_channel(' channels{c} ')_gaze' num2str(gaze) '.mat']
		mat=load(iFactor_channel_path);
		iFactors{c}=mat.matrix_in;
        if ~isempty(aoicoords)
            croppedmatrix=cropmat(iFactors{c},aoicoords(1),aoicoords(3),aoicoords(2),aoicoords(4)); 
        else
            croppedmatrix=iFactors{c};
        end
		[activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(iFactors{c},1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
		activity_mean_s{i}{c}=mean(activity_mean,2);
		activity_mean_o{i}{c}=mean(activity_mean,1);
		activity_mean_c{i}(1,c,:)=mean(mean(activity_mean,2),1);
		activity_mean_all{i}{c}=activity_mean;
		
		
		[activity_mean,activity_mean_mean,activity_max,activity_max_max, activity_sum,activity_sum_sum, activity_single] = show_activity(croppedmatrix,1,struct.zli_params.n_membr,1,struct.zli_params.n_iter,1,struct.wave_params.n_scales-1,1,struct.wave_params.n_orient);
		cropped_activity_mean_s{i}{c}=mean(activity_mean,2);
		cropped_activity_mean_o{i}{c}=mean(activity_mean,1);
		cropped_activity_mean_c{i}(1,c,:)=mean(mean(activity_mean,2),1);
		cropped_activity_mean_all{i}{c}=activity_mean;
	end
	
end




end

