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
            imwrite(mean_smap,[image_props.output_mean_path{1}]);
            
        elseif conf_struct.gaze_params.ngazes ==2
            part = 2:2; %all gazes except first
            mean_smap = get_smaps_mean(smaps,part);
            imwrite(mean_smap,[image_props.output_mean_path_nobaseline{1}]);

            part = 1:2; %all gazes
            mean_smap = get_smaps_mean(smaps,part);
            imwrite(mean_smap,[image_props.output_mean_path{1}]);
        else
            
            for i=1:round(conf_struct.gaze_params.ngazes)
                part = 1:i;
                mean_smap = get_smaps_mean(smaps,part);
                imwrite(mean_smap,[image_props.output_mean_path{i}]);
            end
            
            
            for i=2:round(conf_struct.gaze_params.ngazes)
                part = 2:i;
                mean_smap = get_smaps_mean(smaps,part);
                imwrite(mean_smap,[image_props.output_mean_nobaseline_path{i}]);
            end
    
        end
        
        
        
        
    else
         mean_smap = imread(image_props.output_mean_path{conf_struct.gaze_params.ngazes}); 
        
    end
    
    imwrite(mean_smap,[image_props.output_image_path]);
    
end