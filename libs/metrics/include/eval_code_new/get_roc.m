

function [ roc,  roc_curve] = get_roc( smap, fmap, fmap_other)
    
%     fmap = dmap_to_fmap(fmap);
%     fmap_other = dmap_to_fmap(fmap_other);

    %redondea
    smap=ceil(smap/1);
    fmap=ceil(fmap/1);
    fmap_other=ceil(fmap_other/1);
            
    %calc hist
    map_hist_f1 = get_hist(smap, fmap);
    map_hist_f2 = get_hist(smap, fmap_other);
    

    % ROC curve:
    thres=1:256;
    FP=zeros(length(thres),1);
    TP=zeros(length(thres),1);

    % cumsum descending:
    for i=1:length(thres)
        TP(i)=sum(map_hist_f1(thres(i):end))/sum(map_hist_f1);
        FP(i)=sum(map_hist_f2(thres(i):end))/sum(map_hist_f2);
    end

    % Area under ROC:
    rocarea=0;
    for i=1:length(thres)-1
        rocarea=rocarea+(FP(i)-FP(i+1))*(TP(i+1)+TP(i))/2;
    end
    roc=rocarea;
    roc_curve = [TP FP];

end


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
