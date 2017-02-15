% function [ RFmax_o,residual_o, max_s, max_o, max_c ] = get_waveo_max_t( RF_s_o_c,residual_s_c,n_scales,n_orient,C )
%     RFmax_o = cell(n_orient,1);
%     residual_o = zeros(residual_s_c{1}(:,:,1));
%     
%     for o=1:n_orient
%         RFmax = zeros(size(RF_s_o_c{1}{1}(:,:,1)));
%         residualmax = zeros(residual_s_c{1}(:,:,1));
%         for s=1:n_scales-1
%             for c=1:C
%                 values = RF_s_o_c{s}{o}(:,:,c); 
%                 values_residual = residual_s_c{s}(:,:,c); 
%                 for y=1:size(RF_s_o_c{s}{o},1)
%                     for x=1:size(RF_s_o_c{s}{o},2)
%                         if values(y,x) > RFmax(y,x)
%                             RFmax(y,x) = values(y,x);
%                             residualmax(y,x)= values_residual(y,x);
%                             max_s=s;
%                             max_o=o;
%                             max_c=c;
%                         end
%                     end
%                 end
%             end
%         end
%         RFmax_o{o} = RFmax;
%         residual_o = residualmax;
%     end
% 
% end

