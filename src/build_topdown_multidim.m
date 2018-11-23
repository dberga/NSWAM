function  [ topdown_matrix_multidim ] = build_topdown_multidim( conf_struct, topdown_matrix)
            
        if conf_struct.search_params.topdown==1 %dimensions of topdown_matrix_multidim = (M,N,Scale,Orient,Pol,Channel)
            %set all to ones
            topdown_matrix_multidim=conf_struct.search_params.multiplier.*ones(size(topdown_matrix,1),size(topdown_matrix,2),conf_struct.wave_params.n_scales-1,conf_struct.wave_params.n_orient,2,length(conf_struct.color_params.channels));
            
            %select where not to inhibit (boolean top-down)
            topdown_matrix_multidim(:,:,conf_struct.search_params.scales,conf_struct.search_params.orientations,conf_struct.search_params.polarity,conf_struct.search_params.channels)=repmat(zeros(size(topdown_matrix,1),size(topdown_matrix,2)),1,1,length(conf_struct.search_params.scales),length(conf_struct.search_params.orientations),length(conf_struct.search_params.polarity),length(conf_struct.search_params.channels));
        else
            topdown_matrix_multidim=zeros(size(topdown_matrix,1),size(topdown_matrix,2),conf_struct.wave_params.n_scales-1,conf_struct.wave_params.n_orient,2,length(conf_struct.color_params.channels));
        end
end

%% pseudocode for using image templates instead of boolean selection
% function [values_channel, values_scale, values_orient]= template2activity(image,mask)
%     opp=image2opp(image);
%     for o=1:size(opp,3)
%         wav=opp2wav(opp);
%         for s=1:length(wav)
%             [values_scale]=max(normalize(wav(s)));
%             for o=1:lengt(wav(s))
%                 [values_orient]=max(normalize(wav(s,o)));
%             end
%         end
%     end
%     values_channel=max(normalize(opp));
%     
% end

