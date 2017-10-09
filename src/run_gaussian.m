function [gaussian_smap] = run_gaussian(run_flags,image_props,conf_struct,scanpath)
     if run_flags.run_gaussian
        
        if conf_struct.gaze_params.ngazes <=1
            aux_scanpath = scanpath(2:2,:); %all gazes except first
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_nobaseline_path{1}]);

            aux_scanpath = scanpath(1:2,:); %all gazes
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path{1}]);
        else
            
            for i=2:round(conf_struct.gaze_params.ngazes)
                aux_scanpath = scanpath(2:i,:);
                gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
                imwrite(gaussian_smap,[image_props.output_gaussian_nobaseline_path{i}]);
            end
            
            for i=1:round(conf_struct.gaze_params.ngazes)
                aux_scanpath = scanpath(1:i,:);
                gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
                imwrite(gaussian_smap,[image_props.output_gaussian_path{i}]);
            end
            
        end
        
     else
        gaussian_smap = mat2gray(imread(image_props.output_gaussian_path{conf_struct.gaze_params.ngazes})); 
     end
end
