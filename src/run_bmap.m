function [bmap] = run_bmap(run_flags,image_props,conf_struct,scanpath)
    if run_flags.run_bmap
        
        if conf_struct.gaze_params.ngazes <=1
            aux_scanpath = scanpath(2:2,:); %all gazes except first
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path_nobaseline]);

            aux_scanpath = scanpath(1:2,:); %all gazes
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path]);
        else
            
            aux_scanpath = scanpath(1:3,:); %first 2 gazes
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path_first2]);

            aux_scanpath = scanpath(2:3,:); %first 2 gazes except first
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path_first2_nobaseline]);

            aux_scanpath = scanpath(2:round(conf_struct.gaze_params.ngazes)*1,:); %all gazes except first
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path_nobaseline]);

            aux_scanpath = scanpath(:,:); %all gazes
            bmap = get_smaps_bmap(aux_scanpath,conf_struct);
            imwrite(bmap,[image_props.output_bmap_path]);
        end
        
    else
       bmap = imread(image_props.output_bmap_path); 
    end
end
