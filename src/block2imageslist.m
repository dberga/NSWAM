function [ images_list ] = block2imageslist( blocks_wanted, blocks_cond_wanted )



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

