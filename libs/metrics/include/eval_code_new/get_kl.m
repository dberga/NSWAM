function [ KLD ] = get_kl( smap, fmap, fmap_other)
    
%     fmap = dmap_to_fmap(fmap);
%     fmap_other = dmap_to_fmap(fmap_other);

    %redondea
    smap=ceil(smap/1);
    fmap=ceil(fmap/1);
    fmap_other=ceil(fmap_other/1);
            
    %calc hist
    map_hist_f1 = get_hist(smap, fmap);
    map_hist_f2 = get_hist(smap, fmap_other);
    

    % account for log(0) errors and change to probabilities:
    lg_f1 = (map_hist_f1+1)/sum(map_hist_f1+1);
    lg_f2 = (map_hist_f2+1)/sum(map_hist_f2+1);

    % KL divergence:
    KLD = sum(lg_f2.*log2((lg_f2)./(lg_f1)));
end




% function [fmap] = dmap_to_fmap(dmap)
%         icount = 0;
%         for i=1:size(dmap,1)
%             for j=1:size(dmap,2)
%                
%                if dmap(i,j) > 0
%                    icount = icount+1;
%                    value = dmap(i,j);
%                    
%                    fmap(icount,1) = value;
%                    fmap(icount,2) = icount;
%                end
%             end
%         end
% end

% function [map_hist] = get_hist(map1, map2)
%     % create histogram of map1 values (saliency) at map2 (fixated pts):
%     map_hist=zeros(256,1);                 % distributions
%     for j=1:size(map2,1)
%         map_hist(map1(map2(j,2),map2(j,1))+1)=map_hist(map1(map2(j,2),map2(j,1))+1)+1;
%     end
%     
% end

function [map_hist] = get_hist(map1, map2)
    % create histogram of map1 values (saliency) at map2 (fixated pts):
    map_hist=zeros(256,1);                 % distributions
    
    values_inside = map1(map2>0); % map1 values at map2 locations
    N1 = length(values_inside);
    N2 = length(map1);
    
    map_hist = imhist(values_inside);

    
end






