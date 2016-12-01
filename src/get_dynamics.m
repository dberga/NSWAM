function [iFactors] = get_dynamics(run_flags,loaded_struct,folder_props,image_props,C,gaze_idx,curvs,residuals)
                
    iFactors = cell(1,C);
    for c=1:C
            
        if run_flags.load_iFactor_mats(gaze_idx)==1 && run_flags.load_struct(gaze_idx)==1
            iFactor = load(get_mat_name('iFactor',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c})); iFactor = iFactor.matrix_in;
            %iFactor = iFactor(~cellfun('isempty',iFactor)); %clean void cells
        else
            t_ini = tic;
            switch loaded_struct.compute_params.model
                case -1
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% empty, do not process anything %%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    return;
                case 0
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% COPY (only curv from DWT, dynamic = tmem copies) %%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    iFactor = multires_decomp2dyndecomp(curvs{c},residuals{c},loaded_struct.zli_params.n_membr,loaded_struct.zli_params.n_iter,loaded_struct.wave_params.n_scales);

                case 1
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% NEURODYNAMIC IN MATLAB %%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    [iFactor, iFactor_ON, iFactor_OFF, jFactor_ON, jFactor_OFF] =NCZLd_channel_ON_OFF(curvs{c},loaded_struct,loaded_struct.color_params.channels{c});

                case 2
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%% NEURODYNAMIC IN C++ %%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [iFactor_single,iFactor] = NCZLd_periter_mex(curvs{c},loaded_struct); %iFactor_single has mean of memtime and iter (scale and orientation dimensions)

            end
            toc(t_ini);
            
            
        
            %change its cell dimensions format
            for ff=1:loaded_struct.zli_params.n_membr
                     for iter=1:loaded_struct.zli_params.n_iter
                         [iFactor{ff}{iter},~] = multires_decomp2curv(iFactor{ff}{iter},residuals{c},loaded_struct.wave_params.n_scales,loaded_struct.wave_params.n_orient);
                     end
            end
            
            
            % save computed iFactor
            save_mat('iFactor',iFactor,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c});
            
           
        end
        
        iFactors{c} = iFactor;
        
        
        
    
    end
    
        if C < 2
        %case grayscale
        iFactors{2} = iFactors{1};
        iFactors{3} = iFactors{1};
        save_mat('iFactor',iFactors{2},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
        save_mat('iFactor',iFactors{3},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});
        
        end
end

