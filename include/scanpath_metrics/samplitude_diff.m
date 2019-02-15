function [ mean_amplitude_diff, std_amplitude_diff, amplitudes_diff ] = samplitude_diff( scanpath1,scanpath2 )

min_gazes = min(size(scanpath1,1),size(scanpath2,1));
[~,~,amplitudes1]=samplitude(scanpath1);
[~,~,amplitudes2]=samplitude(scanpath2);

if length(amplitudes1) ~= length(amplitudes2)
    min_gazes_amp=min(length(amplitudes1),length(amplitudes2));
    amplitudes1(min_gazes_amp+1:end)=[];
    amplitudes2(min_gazes_amp+1:end)=[];
end

amplitudes_diff=abs(amplitudes1-amplitudes2);
mean_amplitude_diff=mean(amplitudes_diff);
std_amplitude_diff=std(amplitudes_diff);



end

