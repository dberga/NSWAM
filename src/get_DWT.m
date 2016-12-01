function [curvs,residuals] = get_DWT(run_flags,loaded_struct,folder_props,image_props,C,gaze_idx,input_image)
            
        curvs = cell(C,1);
        residuals = cell(C,1);
            for c=1:C
                if run_flags.load_WavCurv_mats(gaze_idx)==1 && run_flags.load_WavResidual_mats(gaze_idx)==1
                    [curv] = load(get_mat_name('w',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c})); curv = curv.matrix_in;
                    [residual] = load(get_mat_name('c',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c})); residual = residual.matrix_in;
                    curv = curv(~cellfun('isempty',curv)); %clean void cells
                    residual = residual(~cellfun('isempty',residual)); %clean void cells

                else
                    [curv,residual] = multires_dispatcher(input_image(:,:,c), loaded_struct.wave_params.multires,loaded_struct.wave_params.n_scales, loaded_struct.wave_params.n_orient);
                    save_mat('w',curv,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c});
                    save_mat('c',residual,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c});

                end
                curvs{c} = curv;
                residuals{c} = residual;
                
                
            end
            
            if C < 2
            % grayscale case: copy to other channels
            curvs{2} = curvs{1};
            curvs{3} = curvs{1};
            save_mat('w',curvs{2},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
            save_mat('w',curvs{3},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});
            

            
            residuals{2} = residuals{1};
            residuals{3} = residuals{1};
            save_mat('residual',residuals{2},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
            save_mat('residual',residuals{3},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});
            
            end
end




