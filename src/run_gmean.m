function [mean_smap] = run_mean(run_flags,image_props,conf_struct,smaps)
    if run_flags.run_mean 
        
        for k=1:conf_struct.gaze_params.ngazes
           if run_flags.load_smap(k)
              smaps(:,:,k)=double(imread(image_props.output_image_paths{k})); 
           else
              %we have already computed the smaps(k) on previous loop
           end
        end
        
        if conf_struct.gaze_params.ngazes ==1
        
            mean_smap = smaps(:,:,1);
            imwrite(mean_smap,[image_props.output_gaussian_path{1}]);
            
        elseif conf_struct.gaze_params.ngazes ==2
            part = 2:2; %all gazes except first
            switch(conf_struct.fusion_params.tmem_res)
                case 'max'
                    mean_smap = get_smaps_max(smaps,part);
                case 'sum'
                    mean_smap = get_smaps_sum(smaps,part);
                otherwise
                    mean_smap = get_smaps_mean(smaps,part);
            end
            imwrite(mean_smap,[image_props.output_gaussian_nobaseline_path{1}]);

            part = 1:2; %all gazes
            switch(conf_struct.fusion_params.tmem_res)
                case 'max'
                    mean_smap = get_smaps_max(smaps,part);
                case 'sum'
                    mean_smap = get_smaps_sum(smaps,part);
                otherwise
                    mean_smap = get_smaps_mean(smaps,part);
            end
            imwrite(mean_smap,[image_props.output_gaussian_path{1}]);
        else
            
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
    
        end
        
        
        
    else
         mean_smap = imread(image_props.output_gaussian_path{conf_struct.gaze_params.ngazes}); 
        
    end
    
    %imwrite(mean_smap,[image_props.output_image_path]);
    
end