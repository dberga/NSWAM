function  [ topdown_matrix_multidim ] = build_topdown_multidim( conf_struct, topdown_matrix)
            
        if conf_struct.search_params.topdown==1 %dimensions of topdown_matrix_multidim = (M,N,Scale,Orient,Pol,Channel)
            switch (conf_struct.search_params.method)
                case {'max','max2'}
                    %% option 1 set specific search features
                    %apply factor
                    topdown_matrix_multidim=conf_struct.search_params.multiplier.*ones(size(topdown_matrix,1),size(topdown_matrix,2),conf_struct.wave_params.n_scales-1,conf_struct.wave_params.n_orient,2,length(conf_struct.color_params.channels));
                    %select where not to inhibit (boolean top-down)
                    topdown_matrix_multidim(:,:,conf_struct.search_params.scales,conf_struct.search_params.orientations,conf_struct.search_params.polarity,conf_struct.search_params.channels)=repmat(zeros(size(topdown_matrix,1),size(topdown_matrix,2)),1,1,length(conf_struct.search_params.scales),length(conf_struct.search_params.orientations),length(conf_struct.search_params.polarity),length(conf_struct.search_params.channels));

                case 'coefficients'
                    %% option 2 regulate upon template coefficients
                    %set same size
                    topdown_matrix_multidim=repmat(conf_struct.search_params.coefficients,1,1,1,1,size(topdown_matrix,1),size(topdown_matrix,2));
                    topdown_matrix_multidim=permute(topdown_matrix_multidim,[5,6,1,2,3,4]); % move array dimension order
                    %assuming normalized conditions, reverse
                    topdown_matrix_multidim=1-topdown_matrix_multidim; 
                    %apply factor
                    topdown_matrix_multidim=conf_struct.search_params.multiplier.*topdown_matrix_multidim;
            end
        else
            topdown_matrix_multidim=zeros(size(topdown_matrix,1),size(topdown_matrix,2),conf_struct.wave_params.n_scales-1,conf_struct.wave_params.n_orient,2,length(conf_struct.color_params.channels));
        end
end
