function [mean_smap] = run_mean(run_flags,image_props,conf_struct,smaps)
    if run_flags.run_mean || run_flags.run_smap
        
        for k=1:conf_struct.gaze_params.ngazes
           if exist(image_props.output_image_paths{k},'file')
              smaps(:,:,k)=mat2gray(imread(image_props.output_image_paths{k})); 
           else
              imwrite(smaps(:,:,k),image_props.output_image_paths{k});
           end
        end
        
            for i=1:round(conf_struct.gaze_params.ngazes)
                part = 1:i;
                switch(conf_struct.fusion_params.tmem_res)
                    case 'max'
                        mean_smap = get_smaps_max(smaps,part);
                    case 'sum'
                        mean_smap = get_smaps_sum(smaps,part);
                    otherwise
                        mean_smap = get_smaps_mean(smaps,part);
                end
                imwrite(mean_smap,[image_props.output_mean_path{i}]);
            end
            
            
            for i=2:round(conf_struct.gaze_params.ngazes)
                part = 2:i;
                switch(conf_struct.fusion_params.tmem_res)
                    case 'max'
                        mean_smap_nobaseline = get_smaps_max(smaps,part);
                    case 'sum'
                        mean_smap_nobaseline = get_smaps_sum(smaps,part);
                    otherwise
                        mean_smap_nobaseline = get_smaps_mean(smaps,part);
                end
                imwrite(mean_smap_nobaseline,[image_props.output_mean_nobaseline_path{i}]);
            end
            
    else
        mean_smap=mat2gray(imread(image_props.output_image_path));
    end
        
    imwrite(mean_smap,[image_props.output_image_path]);
    
end