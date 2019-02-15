function [ mean_distance, std_distance,distances ] = slanding( scanpath1, scanpath2 )
    min_gazes = min(size(scanpath1,1),size(scanpath2,1));
    distances = zeros(1,min_gazes);
    for k=1:min_gazes 
        distances(k) = pdist([scanpath1(k,1),scanpath1(k,2);scanpath2(k,1),scanpath2(k,2)],'euclidean');
    end
    mean_distance = mean(distances(2:end));
    std_distance=std(distances(2:end));
end

