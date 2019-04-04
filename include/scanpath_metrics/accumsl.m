function [ mean_distance, std_distance,distances ] = accumsl( scanpath1, scanpath2, ff_flags )
    if nargin<3, firstfixation_flag_default; end
    if ff_flags(1) == 1
        scanpath1(1,:)=[];
    end
    if ff_flags(2) == 1
        scanpath2(1,:)=[];
    end
    
    distances=NaN;
    for i=1:size(scanpath1,1)
        for j=1:size(scanpath2,2)
            distances(i,j)=pdist([scanpath1(i,1),scanpath1(i,2);scanpath2(j,1),scanpath2(j,2)],'euclidean'); 
        end
    end
    mean_distance = nanmean(distances(:));
    std_distance=nanstd(distances(:));
end
