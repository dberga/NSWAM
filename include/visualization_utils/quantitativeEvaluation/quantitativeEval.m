function [  ] = quantitativeEval( model_name,model_idx, evaluation_name,evaluation_idx, evaluation_input_values, evaluation_conditions, paths )

    
iter=1;
results_cell=cell(numel(evaluation_input_values)*numel(evaluation_conditions)+1,4);
results_cell{1,1}='evaluation_value';
results_cell{1,2}='saliency_index';
results_cell{1,3}='condition';
results_cell{1,4}='filename';


if ~exist(paths.results_quantitative_csv_paths{evaluation_idx}{model_idx},'file')
for indexImg = 1:numel(evaluation_input_values) %imaxes
    Dat=struct([]);
    for condition=1:numel(evaluation_conditions)
        
    
        
   
    
            %fileparts
            [folder,filename,extension]=fileparts(paths.input_image_paths{evaluation_idx}{condition}{indexImg});
        
            %read image
            input_image = imread(paths.input_image_paths{evaluation_idx}{condition}{indexImg});

            %set output size parameters
            [M, N, C] = size(input_image);

            % read smap
            smap = mat2gray(imread(paths.smap_image_paths{evaluation_idx}{condition}{indexImg}{model_idx}));
            if size(smap,3)>1,smap=mat2gray(rgb2gray(imread(paths.smap_image_paths{evaluation_idx}{condition}{indexImg}{model_idx}))); end
            
            % read mask
            mask = mat2gray(imread(paths.mask_image_paths{evaluation_idx}{condition}{indexImg}));
            if size(mask,3)>1, mask=mat2gray(rgb2gray(imread(paths.mask_image_paths{evaluation_idx}{condition}{indexImg}))); end
            
            %get saliency index
            Sw(indexImg)=getSaliencyIndex(smap,mask);

            Dat(condition).im=input_image;
            Dat(condition).nomeimg=paths.input_image_paths{evaluation_idx}{condition}{indexImg};
            Dat(condition).mapsal=smap;
            Dat(condition).maxtarget=max(max(smap.*mask));
            Dat(condition).max=max(smap(:));
            Dat(condition).min=min(smap(:));     
            Dat(condition).sw=Sw(indexImg);     
            
            results_cell{iter+1,1}=evaluation_input_values{indexImg};
            results_cell{iter+1,2}=Sw(indexImg);
            results_cell{iter+1,3}=evaluation_conditions{condition};
            results_cell{iter+1,4}=[filename extension];
            
            iter = iter+1;
        
    end
    getFigsData(Dat,evaluation_name);
    mkdir(fileparts(paths.results_quantitative_paths{evaluation_idx}{indexImg}{model_idx}));
    saveas(gcf,paths.results_quantitative_paths{evaluation_idx}{indexImg}{model_idx}, 'png');
    close all;

end
    
end
 


if size(results_cell,1)>1
    mkdir(fileparts(paths.results_quantitative_csv_paths{evaluation_idx}{model_idx}));
    w_csv(results_cell,paths.results_quantitative_csv_paths{evaluation_idx}{model_idx});
    runResults_percondition(results_cell);
    saveas(gcf, paths.results_quantitative_lineplot_paths{evaluation_idx}{model_idx}, 'png');
    close all;
end


%end


end

