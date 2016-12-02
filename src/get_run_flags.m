function [run_flags] = get_run_flags(image_props,mat_props,conf_struct)

    
    
    for k=1:conf_struct.gaze_params.ngazes
       run_flags.run_smaps = 0;
       if exist(image_props.output_image_paths{k},'file')==0
           run_flags.load_smap(k)=0;
           run_flags.run_smaps = 1;
       else
           
           run_flags.load_smap(k)=1;
       end
    end
    
    if exist(image_props.output_image_path, 'file') 
        run_flags.run_smap = 0;
     else
        run_flags.run_smap = 1;
    end
    if exist(image_props.output_gaussian_path, 'file') 
        run_flags.run_gaussian = 0;
     else
        run_flags.run_gaussian = 1;
    end
    if exist(image_props.output_bmap_path, 'file') 
        run_flags.run_bmap = 0;
     else
        run_flags.run_bmap = 1;
    end
    
    if exist(image_props.output_mean_path, 'file') 
        run_flags.run_mean = 0;
     else
        run_flags.run_mean = 1;
    end
    
    if exist(image_props.output_scanpath_path, 'file') 
        run_flags.run_scanpath = 0;
     else
        run_flags.run_scanpath = 1;
    end
    
    if exist(image_props.output_image_path, 'file') ...
            && exist(image_props.output_scanpath_path, 'file') ...
            && exist(image_props.output_mean_path, 'file') ...
            && exist(image_props.output_gaussian_path, 'file') ...
            && exist(image_props.output_bmap_path, 'file') 
        run_flags.run_all = 0;
     else
        run_flags.run_all = 1;
    end
    
     for k=1:conf_struct.gaze_params.ngazes
         
         
         if exist(mat_props.loaded_struct_path{k}, 'file') 
             loaded_struct = load(mat_props.loaded_struct_path{k}); loaded_struct = loaded_struct.matrix_in;
             if compare_structs(conf_struct,loaded_struct) == 1
                 run_flags.load_struct(k)=1;
             else
                 run_flags.load_struct(k)=0;
             end
         else
             run_flags.load_struct(k)=0;
         end
         
         if exist(mat_props.op1_iFactor_path{k}, 'file') ...
             && exist(mat_props.op2_iFactor_path{k}, 'file') ...
             && exist(mat_props.op3_iFactor_path{k}, 'file') ...

             run_flags.load_iFactor_mats(k)=1;
         else
             run_flags.load_iFactor_mats(k)=0;
         end
         
         
         if exist(mat_props.op1_WavCurv_path{k}, 'file') ...
             && exist(mat_props.op2_WavCurv_path{k}, 'file') ...
             && exist(mat_props.op3_WavCurv_path{k}, 'file')
         
             run_flags.load_WavCurv_mats(k)=1;
         else
             run_flags.load_WavCurv_mats(k)=0;
         end
         
         if  exist(mat_props.op1_WavResidual_path{k}, 'file') ...
             && exist(mat_props.op2_WavResidual_path{k}, 'file') ...
             && exist(mat_props.op3_WavResidual_path{k}, 'file')
         
             run_flags.load_WavResidual_mats(k)=1;
         else
             run_flags.load_WavResidual_mats(k)=0;
         end
         
         
     end
    

end

