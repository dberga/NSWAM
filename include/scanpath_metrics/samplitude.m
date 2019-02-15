function [ mean_amplitude, std_amplitude, amplitudes ] = samplitude( scanpath )

    if iscell(scanpath)
        [ mean_amplitude, std_amplitude, amplitudes ]=pp_samplitude(scanpath);
    else
        min_gazes = size(scanpath,1);
        amplitudes = zeros(1,min_gazes-1);
        for k=1:min_gazes-1 
            amplitudes(k) = pdist([scanpath(k,1),scanpath(k,2);scanpath(k+1,1),scanpath(k+1,2)],'euclidean');
        end
        mean_amplitude = mean(amplitudes);
        std_amplitude=std(amplitudes);
    end
end

