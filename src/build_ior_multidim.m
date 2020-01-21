function [ ior_matrix_multidim, ior_multidim_set ] = build_ior_multidim( conf_struct,ior_matrix )


if conf_struct.gaze_params.ior_multidim_set==1  %dimensions of ior_matrix_multidim = (M,N,Scale,Orient,Pol,Channel)
            
            ior_matrix_multidim= get_ior_update(conf_struct.gaze_params.ior_matrix_multidim,conf_struct);
            size(ior_matrix_multidim)
            size((ior_matrix .*conf_struct.gaze_params.max_mempotential_val))
            try
                switch conf_struct.gaze_params.ior 
                    case 1 %apply ior to specific scale, channel, orientation and polarity (on/off)
                     ior_matrix_multidim(:,:,conf_struct.gaze_params.maxidx_s,conf_struct.gaze_params.maxidx_o,conf_struct.gaze_params.idx_max_mempotential_polarity,conf_struct.gaze_params.maxidx_c) = ior_matrix_multidim(:,:,conf_struct.gaze_params.maxidx_s,conf_struct.gaze_params.maxidx_o,conf_struct.gaze_params.idx_max_mempotential_polarity,conf_struct.gaze_params.maxidx_c) + (ior_matrix .*conf_struct.gaze_params.max_mempotential_val);
                    case 2 %apply ior to specific channel, orientation and polarity (on/off)
                     ior_matrix_multidim(:,:,:,conf_struct.gaze_params.maxidx_o,conf_struct.gaze_params.idx_max_mempotential_polarity,conf_struct.gaze_params.maxidx_c) = ior_matrix_multidim(:,:,:,conf_struct.gaze_params.maxidx_o,conf_struct.gaze_params.idx_max_mempotential_polarity,conf_struct.gaze_params.maxidx_c) + (ior_matrix .*conf_struct.gaze_params.max_mempotential_val);
                    case 3 %apply ior to specific scale, channel and polarity (on/off)
                     ior_matrix_multidim(:,:,conf_struct.gaze_params.maxidx_s,:,conf_struct.gaze_params.idx_max_mempotential_polarity,conf_struct.gaze_params.maxidx_c) = ior_matrix_multidim(:,:,conf_struct.gaze_params.maxidx_s,:,conf_struct.gaze_params.idx_max_mempotential_polarity,conf_struct.gaze_params.maxidx_c) + (ior_matrix .*conf_struct.gaze_params.max_mempotential_val);
                    case 4 %apply ior to specific scale and channel
                     ior_matrix_multidim(:,:,conf_struct.gaze_params.maxidx_s,:,:,conf_struct.gaze_params.maxidx_c) = ior_matrix_multidim(:,:,conf_struct.gaze_params.maxidx_s,:,:,conf_struct.gaze_params.maxidx_c) + (ior_matrix .*conf_struct.gaze_params.max_mempotential_val);
                    case 5 %apply ior to specific channel
                     ior_matrix_multidim(:,:,:,:,:,conf_struct.gaze_params.maxidx_c) = ior_matrix_multidim(:,:,:,:,:,conf_struct.gaze_params.maxidx_c) + (ior_matrix .*conf_struct.gaze_params.max_mempotential_val);
                    case 6 %apply ior to all dimensions
                     ior_matrix_multidim(:,:,:,:,:,:) = ior_matrix_multidim(:,:,:,:,:,:) + (ior_matrix .*conf_struct.gaze_params.max_mempotential_val);
                    otherwise
                     ior_matrix_multidim=zeros(size(ior_matrix,1),size(ior_matrix,2),conf_struct.wave_params.n_scales-1,conf_struct.wave_params.n_orient,2,length(conf_struct.color_params.channels));
                end
            catch
                ior_matrix=replicate_size(ior_matrix, conf_struct.gaze_params.ior );
                [ ior_matrix_multidim, ~ ] = build_ior_multidim( conf_struct,ior_matrix );
            end
else
   ior_matrix_multidim=zeros(size(ior_matrix,1),size(ior_matrix,2),conf_struct.wave_params.n_scales-1,conf_struct.wave_params.n_orient,2,length(conf_struct.color_params.channels));
end
ior_multidim_set=1;

end

function [ior_matrix] = replicate_size(ior_matrix, ior)
    
    switch ior 
        case 1 %apply ior to specific scale, channel, orientation and polarity (on/off)
         %ior_matrix=ior_matrix;
        case 2 %apply ior to specific channel, orientation and polarity (on/off)
         ior_matrix=repmat(ior_matrix,1,1,size(ior_matrix_multidim,3),1,1,1);
        case 3 %apply ior to specific scale, channel and polarity (on/off)
         ior_matrix=repmat(ior_matrix,1,1,size(ior_matrix_multidim,4),1,1);
        case 4 %apply ior to specific scale and channel
         ior_matrix=repmat(ior_matrix,1,1,1,size(ior_matrix_multidim,4),size(ior_matrix_multidim,5),1);
        case 5 %apply ior to specific channel
         ior_matrix=repmat(ior_matrix,1,1,size(ior_matrix_multidim,3),size(ior_matrix_multidim,4),size(ior_matrix_multidim,5),1);
        case 6 %apply ior to all dimensions
         ior_matrix=repmat(ior_matrix,1,1,size(ior_matrix_multidim,3),size(ior_matrix_multidim,4),size(ior_matrix_multidim,5),size(ior_matrix_multidim,6));
        otherwise
         %ior_matrix=ior_matrix;
    end
end