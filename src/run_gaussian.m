function [gaussian_smap] = run_gaussian(run_flags,image_props,conf_struct,scanpath)
    if run_flags.run_gaussian
        
        if conf_struct.gaze_params.ngazes <=1
            aux_scanpath = scanpath(2:2,:); %all gazes except first
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path_nobaseline]);

            aux_scanpath = scanpath(1:2,:); %all gazes
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path]);
        else
            
            aux_scanpath = scanpath(1:3,:); %first 2 gazes
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path_first2]);

            aux_scanpath = scanpath(2:3,:); %first 2 gazes except first
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path_first2_nobaseline]);

            aux_scanpath = scanpath(2:round(conf_struct.gaze_params.ngazes)*1,:); %all gazes except first
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path_nobaseline]);

            aux_scanpath = scanpath(:,:); %all gazes
            gaussian_smap = get_smaps_gaussian(aux_scanpath,conf_struct);
            imwrite(gaussian_smap,[image_props.output_gaussian_path]);
        end
        
    else
       gaussian_smap = imread(image_props.output_gaussian_path); 
    end
end
