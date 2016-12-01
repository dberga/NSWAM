function [scanpath] = run_scanpath(run_flags,image_props,conf_struct,smaps)
    if run_flags.run_scanpath
        for k=1:conf_struct.gaze_params.ngazes
            if run_flags.load_smap(k)
                  smaps(:,:,k)=double(imread(image_props.output_image_paths{k})); 
            else
               %we have already computed the smaps(k) on previous loop
            end
        end
        [scanpath] = get_scanpath(smaps,conf_struct);
        
        save(image_props.output_scanpath_path,'scanpath');


    else
        scanpath = load(image_props.output_scanpath_path); scanpath = scanpath.scanpath;
    end
end
