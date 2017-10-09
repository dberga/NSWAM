function [bmap] = run_bmap(run_flags,image_props,conf_struct,scanpath)
    if run_flags.run_bmap
        
        if conf_struct.gaze_params.ngazes <=1
            aux_scanpath = scanpath(2:2,:); %all gazes except first
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_nobaseline_path{1}]);

            aux_scanpath = scanpath(1:2,:); %all gazes
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path{1}]);
        else
            for i=2:round(conf_struct.gaze_params.ngazes)
                aux_scanpath = scanpath(2:i,:);
                bmap = get_smaps_bmap(aux_scanpath,conf_struct);
                imwrite(bmap,[image_props.output_bmap_nobaseline_path{i}]);
            end
            
            for i=1:round(conf_struct.gaze_params.ngazes)
                aux_scanpath = scanpath(1:i,:);
                bmap = get_smaps_bmap(aux_scanpath,conf_struct);
                imwrite(bmap,[image_props.output_bmap_path{i}]);
            end
        end
        
    else
       bmap = mat2gray(imread(image_props.output_bmap_path{conf_struct.gaze_params.ngazes})); 
    end
end
