function [ ] = qualitativeEval( model_name, model_idx ,evaluation_name, evaluation_idx, evaluation_input_values, evaluation_conditions, paths )


for indexImg = 1:numel(evaluation_input_values) %imaxes
    for condition=1:numel(evaluation_conditions)
    
        %read image
        input_image = imread(paths.input_image_paths{evaluation_idx}{condition}{indexImg});

        %set output size parameters
        [M, N, C] = size(input_image);

        % read smap
        smap = mat2gray(imread(paths.smap_image_paths{evaluation_idx}{condition}{indexImg}{model_idx}));
        if size(smap,3)>1,smap=mat2gray(rgb2gray(imread(paths.smap_image_paths{evaluation_idx}{condition}{indexImg}{model_idx}))); end

        % read mask
        mask = mat2gray(imread(paths.mask_image_paths{evaluation_idx}{condition}{indexImg}));
        if size(mask,3)>1, mask=mat2gray(imread(paths.mask_image_paths{evaluation_idx}{condition}{indexImg})); end
        
        if ~exist(paths.results_qualitative_paths{evaluation_idx}{condition}{indexImg}{model_idx},'file') 
            mkdir(fileparts(paths.results_qualitative_paths{evaluation_idx}{condition}{indexImg}{model_idx}));
            %create figure
            figure(10);
            subplot(1,2,1)
            model_name,evaluation_name
            imshow(smap,[]);
            subplot(1,2,2)
            imshow(superpos_map(input_image,smap),[]);
            saveas(gcf, paths.results_qualitative_paths{evaluation_idx}{condition}{indexImg}{model_idx}, 'png');
        end
end

end



