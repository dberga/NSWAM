function [mean_smap] = run_gmean(run_flags,image_props,conf_struct,smaps)
    if run_flags.run_gaussian 
        
        for k=1:conf_struct.gaze_params.ngazes
           if ~run_flags.run_smaps
              smaps(:,:,k)=double(imread(image_props.output_gaussian_path{k})); 
           else
              %we have already computed the smaps(k) on previous loop
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
                imwrite(mean_smap,[image_props.output_gaussian_path{i}]);
            end
            
            
            for i=2:round(conf_struct.gaze_params.ngazes)
                part = 2:i;
                switch(conf_struct.fusion_params.tmem_res)
                    case 'max'
                        mean_smap = get_smaps_max(smaps,part);
                    case 'sum'
                        mean_smap = get_smaps_sum(smaps,part);
                    otherwise
                        mean_smap = get_smaps_mean(smaps,part);
                end
                imwrite(mean_smap,[image_props.output_gaussian_nobaseline_path{i}]);
            end
            
    else
        mean_smap=imread(image_props.output_gaussian_path{conf_struct.gaze_params.ngazes});
    end
        
    %imwrite(mean_smap,[image_props.output_image_path]);
    
end