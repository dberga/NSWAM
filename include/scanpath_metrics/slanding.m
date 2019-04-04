function [ mean_distance, std_distance,distances ] = slanding( scanpath1, scanpath2, ff_flags )
    if nargin<3, firstfixation_flag_default; end
    if ff_flags(1) == 1
        scanpath1(1,:)=[];
    end
    if ff_flags(2) == 1
        scanpath2(1,:)=[];
    end
    
    min_gazes = min(size(scanpath1,1),size(scanpath2,1));
    distances = zeros(1,min_gazes);
    for k=1:min_gazes 
        distances(k) = pdist([scanpath1(k,1),scanpath1(k,2);scanpath2(k,1),scanpath2(k,2)],'euclidean');
    end
    mean_distance = nanmean(distances(2:end));
    std_distance=nanstd(distances(2:end));
end

