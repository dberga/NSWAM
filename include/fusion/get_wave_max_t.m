% function [ RFmax, residual_max, max_s, max_o ] = get_wave_max_t( RF_s_o,residual, n_scales, n_orient )
% 
%     RFmax = zeros(size(RF_s_o{1}{1}(:,:,1)));
%     
% 	for s=1:n_scales-1
%         for o=1:n_orient
%             values = RF_s_o{s}{o}(:,:); 
%             for y=1:size(RF_s_o{s}{o},1)
%                 for x=1:size(RF_s_o{s}{o},2)
%                     if values(y,x) > RFmax(y,x)
%                         RFmax(y,x) = values(y,x);
%                         max_s=s;
%                         max_o=o;
%                     end
%                 end
%             end
%         end
%     end
%     
% end

