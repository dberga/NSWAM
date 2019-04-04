function [ mean_amplitude, std_amplitude, amplitudes ] = samplitude( scanpath , ff_flag)
    if nargin<2, firstfixation_flag_default; end
    if ff_flag(1) == 1
        scanpath(1,:)=[];
    end
    
    if iscell(scanpath)
        [ mean_amplitude, std_amplitude, amplitudes ]=pp_samplitude(scanpath);
    else
        if ff_flag == 1
            scanpath(1,:)=[];
        end
        min_gazes = size(scanpath,1);
        amplitudes = zeros(1,min_gazes-1);
        for k=1:min_gazes-1 
            amplitudes(k) = pdist([scanpath(k,1),scanpath(k,2);scanpath(k+1,1),scanpath(k+1,2)],'euclidean');
        end
        mean_amplitude = nanmean(amplitudes);
        std_amplitude=nanstd(amplitudes);
    end
end

