function [iFactors] = get_dynamics(run_flags,loaded_struct,folder_props,image_props,C,gaze_idx,curvs,residuals)
    

    iFactors = cell(1,C);


    for c=1:C
        
        loaded_struct_path=get_mat_name('struct',folder_props,image_props,gaze_idx);
        [ loaded_struct_equivalent_path , mfolder, folder_equivalent,iname_equivalent,k_equivalent] = get_samemat( loaded_struct_path );
        
        if numel(loaded_struct_equivalent_path)>0
            iFactor_path_equivalent=[mfolder '/' folder_equivalent '/' iname_equivalent '_iFactor_channel(' loaded_struct.color_params.channels{c} ')_gaze' k_equivalent '.mat'];
            xon_path_equivalent=[mfolder '/' folder_equivalent '/' iname_equivalent '_xon_channel(' loaded_struct.color_params.channels{c} ')_gaze' k_equivalent '.mat'];
            xoff_path_equivalent=[mfolder '/' folder_equivalent '/' iname_equivalent '_xoff_channel(' loaded_struct.color_params.channels{c} ')_gaze' k_equivalent '.mat'];
            yon_path_equivalent=[mfolder '/' folder_equivalent '/' iname_equivalent '_yon_channel(' loaded_struct.color_params.channels{c} ')_gaze' k_equivalent '.mat'];
            yoff_path_equivalent=[mfolder '/' folder_equivalent '/' iname_equivalent '_yoff_channel(' loaded_struct.color_params.channels{c} ')_gaze' k_equivalent '.mat'];
            
            if exist(iFactor_path_equivalent,'file') && ... %reuse other iFactor if struct parameters are equivalent
                   exist(xon_path_equivalent,'file') && ...
                   exist(xoff_path_equivalent,'file') && ...
                   exist(yon_path_equivalent,'file') && ...
                   exist(yoff_path_equivalent,'file') 

                    run_flags.load_iFactor_mats(gaze_idx)=1;

                    iFactor_path_current=[mfolder '/' folder_props.output_subfolder '/' iname_equivalent '_iFactor_channel(' loaded_struct.color_params.channels{c} ')_gaze' num2str(gaze_idx) '.mat'];
                        system(['ln -sf ' strrep(strrep(iFactor_path_equivalent,'(','\('),')','\)') ' ' strrep(strrep(iFactor_path_current,'(','\('),')','\)')]);

                    xon_path_current=[mfolder '/' folder_props.output_subfolder '/' iname_equivalent '_xon_channel(' loaded_struct.color_params.channels{c} ')_gaze' num2str(gaze_idx) '.mat'];
                        system(['ln -sf ' strrep(strrep(xon_path_equivalent,'(','\('),')','\)') ' ' strrep(strrep(xon_path_current,'(','\('),')','\)')]);

                    xoff_path_current=[mfolder '/' folder_props.output_subfolder '/' iname_equivalent '_xoff_channel(' loaded_struct.color_params.channels{c} ')_gaze' num2str(gaze_idx) '.mat'];
                        system(['ln -sf ' strrep(strrep(xoff_path_equivalent,'(','\('),')','\)') ' ' strrep(strrep(xoff_path_current,'(','\('),')','\)')]);

                    yon_path_current=[mfolder '/' folder_props.output_subfolder '/' iname_equivalent '_yon_channel(' loaded_struct.color_params.channels{c} ')_gaze' num2str(gaze_idx) '.mat'];
                        system(['ln -sf ' strrep(strrep(yon_path_equivalent,'(','\('),')','\)') ' ' strrep(strrep(yon_path_current,'(','\('),')','\)')]);

                    yoff_path_current=[mfolder '/' folder_props.output_subfolder '/' iname_equivalent '_yoff_channel(' loaded_struct.color_params.channels{c} ')_gaze' num2str(gaze_idx) '.mat'];
                        system(['ln -sf ' strrep(strrep(yoff_path_equivalent,'(','\('),')','\)') ' ' strrep(strrep(yoff_path_current,'(','\('),')','\)')]);
            end
        end
        if run_flags.load_iFactor_mats(gaze_idx)==1 %&& run_flags.load_xon_mats(gaze_idx)==1 && run_flags.load_xoff_mats(gaze_idx)==1 && run_flags.load_yon_mats(gaze_idx)==1 && run_flags.load_yoff_mats(gaze_idx)==1
            iFactor = load(get_mat_name('iFactor',folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c})); iFactor = iFactor.matrix_in;
            %iFactor = iFactor(~cellfun('isempty',iFactor)); %clean void cells

            %last_xon = load(get_mat_name('xon',folder_props,image_props,gaze_idx-1,loaded_struct.color_params.channels{c})); last_xon = last_xon.matrix_in;
            %last_xoff = load(get_mat_name('xoff',folder_props,image_props,gaze_idx-1,loaded_struct.color_params.channels{c})); last_xoff = last_xoff.matrix_in;
            %last_yon = load(get_mat_name('yon',folder_props,image_props,gaze_idx-1,loaded_struct.color_params.channels{c})); last_yon = last_yon.matrix_in;
            %last_yoff = load(get_mat_name('yoff',folder_props,image_props,gaze_idx-1,loaded_struct.color_params.channels{c})); last_yoff = last_yoff.matrix_in;

            
        else
           
                if gaze_idx <=1 || loaded_struct.gaze_params.conserve_dynamics == 0 || loaded_struct.compute_params.model ~= 1
                    last_xon = zeros(size(curvs{c}{1},1),size(curvs{c}{1},2),size(curvs{c},1),size(curvs{c}{1},3)); %M,N,S,O
                    last_xoff = zeros(size(curvs{c}{1},1),size(curvs{c}{1},2),size(curvs{c},1),size(curvs{c}{1},3)); %M,N,S,O
                    last_yon = zeros(size(curvs{c}{1},1),size(curvs{c}{1},2),size(curvs{c},1),size(curvs{c}{1},3)); %M,N,S,O
                    last_yoff = zeros(size(curvs{c}{1},1),size(curvs{c}{1},2),size(curvs{c},1),size(curvs{c}{1},3)); %M,N,S,O
                else
                    last_xon = load(get_mat_name('xon',folder_props,image_props,gaze_idx-1,loaded_struct.color_params.channels{c})); last_xon = last_xon.matrix_in;
                    last_xoff = load(get_mat_name('xoff',folder_props,image_props,gaze_idx-1,loaded_struct.color_params.channels{c})); last_xoff = last_xoff.matrix_in;
                    last_yon = load(get_mat_name('yon',folder_props,image_props,gaze_idx-1,loaded_struct.color_params.channels{c})); last_yon = last_yon.matrix_in;
                    last_yoff = load(get_mat_name('yoff',folder_props,image_props,gaze_idx-1,loaded_struct.color_params.channels{c})); last_yoff = last_yoff.matrix_in;
                end

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

                        [~,iFactor, last_xon, last_xoff, last_yon, last_yoff] =NCZLd_channel_ON_OFF(curvs{c},loaded_struct,last_xon, last_xoff, last_yon, last_yoff);

                        %let the dynamics rest for 3 tmem before next saccade
                        [~,~, last_xon, last_xoff, last_yon, last_yoff] =NCZLd_channel_ON_OFF_rest(loaded_struct,last_xon, last_xoff, last_yon, last_yoff);

                    case 2
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%% NEURODYNAMIC IN C++ %%%%%%%
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        [~,iFactor, last_xon, last_xoff, last_yon, last_yoff] = NCZLd_channel_ON_OFF_cpp(curvs{c},loaded_struct,last_xon, last_xoff, last_yon, last_yoff); %iFactor_single has mean of memtime and iter (scale and orientation dimensions)

                        %let the dynamics rest for 3 tmem before next saccade
                        [~,~, last_xon, last_xoff, last_yon, last_yoff] =NCZLd_channel_ON_OFF_rest_cpp(loaded_struct,last_xon, last_xoff, last_yon, last_yoff);
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
                save_mat('xon',last_xon,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c});
                save_mat('yon',last_yon,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c});
                save_mat('xoff',last_xoff,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c});
                save_mat('yoff',last_yoff,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{c});

           
        end
        
        
        
        
        iFactors{c} = iFactor;
            
            
        if C < 2
            %case grayscale
            
            
            iFactors{2} = iFactors{1};
            iFactors{3} = iFactors{1};
            
            
            save_mat('iFactor',iFactors{1},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
            save_mat('iFactor',iFactors{1},folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});
                        
            save_mat('xon',last_xon,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
            save_mat('xon',last_xon,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});
            
            save_mat('yon',last_yon,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
            save_mat('yon',last_yon,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});
            
            save_mat('xoff',last_xoff,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
            save_mat('xoff',last_xoff,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});
            
            save_mat('yoff',last_yoff,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{2});
            save_mat('yoff',last_yoff,folder_props,image_props,gaze_idx,loaded_struct.color_params.channels{3});

        end
    
    end
end

